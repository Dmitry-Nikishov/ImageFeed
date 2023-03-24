//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 24.03.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage = UserDefaults.standard
    private let bearerTokenStorage = "bearer"
    
    var token: String? {
        get {
            storage.string(forKey: bearerTokenStorage)
        }
        
        set {
            storage.set(newValue, forKey: bearerTokenStorage)
        }
    }
}
