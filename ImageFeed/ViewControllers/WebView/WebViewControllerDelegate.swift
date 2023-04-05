//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 05.04.2023.
//

import Foundation

protocol WebViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewController)
}
