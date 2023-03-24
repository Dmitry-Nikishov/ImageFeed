//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 24.03.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = OAuth2TokenStorage().token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: App.IB.showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == App.IB.showAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                fatalError("Segue preparation failure: \(App.IB.showAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")
        }
        
        let tabBarController = UIStoryboard(
            name: App.IB.mainBundleName,
            bundle: .main
        ).instantiateViewController(
            withIdentifier: App.IB.tabBarControllerName
        )
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
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
            case .failure:
                break
            }
        }
    }
}


