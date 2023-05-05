//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 05.04.2023.
//

import UIKit

final class TabBarController: AppStyledTabBarController {
    private typealias ViewControllerWithIconName =
    (vc: UIViewController, iconName: String )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarView()
    }
    
    private func createAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .appBackground
        return appearance
    }

    private func createProfileViewController() -> ProfileViewController {
        let presenter = ProfileViewPresenter(
            uiWindowProvider: UIWindowProvider(),
            rootVcSetter: RootViewControllerSetter(),
            logoutCleaner: LogoutCleaner()
        )
        
        let vc = ProfileViewController()
        vc.presenter = presenter
        presenter.view = vc
        
        return vc
    }
    
    private func createImagesListViewController() -> ImagesListViewController {
        let presenter = ImagesListViewPresenter()
        let vc = ImagesListViewController()
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
    
    private func createControllerContent() -> [ViewControllerWithIconName] {
        [
            (vc: createImagesListViewController(),
             iconName: "tab_editorial_active"),
            
            (vc: createProfileViewController(),
             iconName: "tab_profile_active")
        ]
    }
    
    private func setupTabBarView() {
        tabBar.standardAppearance = createAppearance()
        tabBar.tintColor = .white
        
        let controllerContent = createControllerContent()
        
        self.viewControllers = controllerContent.map{$0.vc}
        let iconsName = controllerContent.map{$0.iconName}
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.image = UIImage(named: iconsName[$0])
            $1.tabBarItem.imageInsets = UIEdgeInsets(
                top: 5,
                left: .zero,
                bottom: -5,
                right: .zero
            )
        }
    }
}
