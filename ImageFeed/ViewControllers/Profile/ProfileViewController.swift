//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 02.03.2023.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    
    func handleAvatarUpdate(
        with url: Resource?,
        placeholder: Placeholder?
    )
}

final class ProfileViewController:
    AppStyledViewController & ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    
    private let profileService = ProfileService.shared
    private var gradientViews = Set<UIView>()

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
        view.accessibilityIdentifier = "logoutButton"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "logout_button"), for: .normal)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupGradient()
        setupHandlers()
        
        updateProfileDetails(with: profileService.profile)
    
        presenter?.requestAvatarUpdate()
    }
        
    private func setupGradientItem(gradientView: UIView, item: UIView) {
        gradientView.createAnimatedGradient()
        item.addSubview(gradientView)
        gradientViews.insert(gradientView)
    }
    
    private func setupGradient() {
        setupGradientItem(
            gradientView: GradientViewBuilder.create(for: .avatar),
            item: avatarImageView
        )

        setupGradientItem(
            gradientView: GradientViewBuilder.create(for: .login),
            item: loginLabel
        )

        setupGradientItem(
            gradientView: GradientViewBuilder.create(for: .name),
            item: nameLabel
        )
    }
    
    private func deleteGradient() {
        gradientViews.forEach { $0.deleteAnimatedGradient() }
    }

    private func setupViews() {
        view.backgroundColor = .appBackground
        
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

    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }
        self.nameLabel.text = profile.name
        self.loginLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
            
    private func setupHandlers() {
        logoutButton.addTarget(
            self,
            action: #selector(didTapLogoutButton),
            for: .touchUpInside
        )
    }
    
    @objc private func didTapLogoutButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        
        let yesAction = UIAlertAction(title: "Да", style: .cancel) {
            [weak self] _ in
            self?.presenter?.requestLogout()
        }
        alert.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Нет", style: .default)
        alert.addAction(noAction)
        
        self.present(alert, animated: true)
    }
}

extension ProfileViewController {
    func handleAvatarUpdate(
        with url: Resource?,
        placeholder: Placeholder?
    ) {
        avatarImageView.kf.setImage(
            with: url,
            placeholder: placeholder
        ) { [weak self] _ in
            self?.gradientViews.forEach { $0.deleteAnimatedGradient() }
        }
    }
}
