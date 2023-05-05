//
//  UIWindowProvider.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import UIKit

public protocol UIWindowProviderProtocol {
    func getFirstWindow() -> UIWindow?
}

final class UIWindowProvider: UIWindowProviderProtocol {
    func getFirstWindow() -> UIWindow? {
        UIApplication.shared.windows.first
    }
}
