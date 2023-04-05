//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 05.04.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    )
}
