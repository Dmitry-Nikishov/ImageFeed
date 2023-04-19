//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 24.03.2023.
//

import UIKit

final class SplashViewController: AppStyledViewController {
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageServices.shared
    
    private lazy var splashLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "splash_screen_logo")
        return imageView
    }()

    override func viewDidLoad() {
        view.backgroundColor = .appBackground
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenStorage.shared.token {
            fetchProfile(token)
        } else {
            showAuthViewController()
        }
    }
    
    private func showAlert(with error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему. Ошибка: \(error)",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func setupView() {
        view.addSubview(splashLogoImageView)
        
        let constraints = [
            splashLogoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            splashLogoImageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        
        let navigationAuthViewController = UINavigationController(rootViewController: authViewController)
        navigationAuthViewController.modalPresentationStyle = .fullScreen
        present(navigationAuthViewController, animated: true)
    }
}

extension SplashViewController {
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")
        }

        window.rootViewController = TabBarController()
        window.makeKeyAndVisible()
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            self?.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            switch result {
            case .success(let response):
                self?.oauth2TokenStorage.token = response.accessToken
                self?.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                self?.showAlert(with: error)
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
}

extension SplashViewController {
    private func fetchProfile(_ token: String?) {
        guard let token  else { return }
        profileService.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let userProfile):
                UIBlockingProgressHUD.dismiss()
                self?.profileImageService.fetchProfileImageURL(username: userProfile.username) { _ in }
                self?.switchToTabBarController()
            case .failure(let error):
                self?.showAlert(with: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}


