//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 22.03.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    private lazy var logoImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "auth_screen_logo")
        return view
    }()
    
    @objc private func didTapLoginButton() {
        let vc = WebViewController()
        vc.delegate = self
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 16
        button.setTitle("Войти", for: .normal)
        
        button.addTarget(
            self,
            action: #selector(didTapLoginButton),
            for: .touchUpInside
        )
        return button
    }()

    weak var delegate: AuthViewControllerDelegate?
    
    private func setupView() {
        view.addSubview(logoImageView)
        view.addSubview(loginButton)

        let constraints = [
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]

        NSLayoutConstraint.activate(constraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension AuthViewController: WebViewControllerDelegate {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewController) {
        dismiss(animated: true)
    }
}
