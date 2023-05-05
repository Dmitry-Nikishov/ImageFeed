//
//  LogoutCleaner.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import Foundation

public protocol LogoutCleanerProtocol {
    func performCleanUp()
}

final class LogoutCleaner: LogoutCleanerProtocol {
    private var oauth2TokenStorage = OAuth2TokenStorage.shared
    
    func performCleanUp() {
        oauth2TokenStorage.deleteToken()
        BrowserCacheCleaner.clean()
    }
}
