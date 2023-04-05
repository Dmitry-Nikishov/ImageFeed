//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 05.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private typealias ViewControllerWithIconName =
    (vc: UIViewController, iconName: String )
    
    private func createAppearance() -> UITabBarAppearance {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .black
        return appearance
    }

    private func createControllerContent() -> [ViewControllerWithIconName] {
        [
            (vc: ImagesListViewController(),
             iconName: "tab_editorial_active"),
            
            (vc: ProfileViewController(),
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarView()
    }

    
}
