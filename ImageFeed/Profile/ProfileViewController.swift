//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 02.03.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "avatar")
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 35
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.text = "Екатерина Новикова"
        view.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        return view
    }()

    private lazy var loginLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1)
        view.text = "@ekaterina_nov"
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return view
    }()

    private lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        view.text = "Hello, World!"
        view.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return view
    }()
    
    private lazy var logoutButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "logout_button"), for: .normal)
        return view
    }()

    
    private func setupViews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
        
        let safeArea = view.safeAreaLayoutGuide

        let constraints = [
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32),
            avatarImageView.leftAnchor.constraint(equalTo: safeArea.leftAnchor, constant: 16),
            
            logoutButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 55),
            logoutButton.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            logoutButton.leftAnchor.constraint(greaterThanOrEqualTo: avatarImageView.rightAnchor),
            
            nameLabel.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: safeArea.rightAnchor, constant: -16),
            
            loginLabel.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor),
            loginLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor),
            
            descriptionLabel.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 8),
            descriptionLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func didTapLogoutButton() {
    }
    
    private func setupHandlers() {
        logoutButton.addTarget(self, action: #selector(didTapLogoutButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupHandlers()
    }
}
