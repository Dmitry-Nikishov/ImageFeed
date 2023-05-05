//
//  RootViewControllerSetter.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import UIKit

public protocol RootViewControllerSetterProtocol {
    func setRootViewController(for: UIWindow, controller: UIViewController)
}

final class RootViewControllerSetter: RootViewControllerSetterProtocol {
    func setRootViewController(
        for window: UIWindow,
        controller: UIViewController
    ) {
        window.rootViewController = controller
        window.makeKeyAndVisible()
    }
}
