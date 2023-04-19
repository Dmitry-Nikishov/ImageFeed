//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 24.03.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let storage = KeychainWrapper.standard
    private let bearerTokenStorage = "bearer"
    
    private init() {}
    
    var token: String? {
        get {
            storage.string(forKey: bearerTokenStorage)
        }
        
        set {
            guard let data = newValue else { return }
            storage.set(data, forKey: bearerTokenStorage)
        }
    }
    
    func deleteToken() {
        storage.removeObject(forKey: bearerTokenStorage)
    }
}
