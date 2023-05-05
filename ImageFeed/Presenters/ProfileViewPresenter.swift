//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import UIKit

public protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    
    func requestAvatarUpdate()
    func requestLogout()
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {    
    private let uiWindowProvider: UIWindowProviderProtocol
    private let rootVcSetter: RootViewControllerSetterProtocol
    private let logoutCleaner: LogoutCleanerProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    
    weak var view: ProfileViewControllerProtocol?
    
    init(
        uiWindowProvider: UIWindowProviderProtocol,
        rootVcSetter: RootViewControllerSetterProtocol,
        logoutCleaner: LogoutCleanerProtocol
    ) {
        self.uiWindowProvider = uiWindowProvider
        self.rootVcSetter = rootVcSetter
        self.logoutCleaner = logoutCleaner
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageServices.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.requestAvatarUpdate()
                }
    }
    
    private func createPlaceholderImage() -> UIImage? {
        return PlaceholderImageCreator.create(
            name: "person.crop.circle.fill",
            size: 70.0
        )
    }

    func requestAvatarUpdate() {
        guard
            let profileImageURL = ProfileImageServices.shared.avatarURL,
            let url = URL(string: profileImageURL),
            let placeholder = createPlaceholderImage()
        else {
            return
        }

        view?.handleAvatarUpdate(with: url, placeholder: placeholder)
    }
    
    func requestLogout() {
        guard let window = uiWindowProvider.getFirstWindow() else {
            Logger.error("UIApplication.shared.windows.first is nil")
            return
        }

        logoutCleaner.performCleanUp()
        
        rootVcSetter.setRootViewController(
            for: window,
            controller: SplashViewController()
        )
    }
}
