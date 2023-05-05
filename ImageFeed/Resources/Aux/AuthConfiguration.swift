//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(
        accessKey: String,
        secretKey: String,
        redirectURI: String,
        accessScope: String,
        authURLString: String,
        defaultBaseURL: URL
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: AppConstants.UnsplashApi.accessKey,
            secretKey: AppConstants.UnsplashApi.secretKey,
            redirectURI: AppConstants.UnsplashApi.redirectURI,
            accessScope: AppConstants.UnsplashApi.accessScope,
            authURLString: AppConstants.UnsplashApi.unsplashAuthorizeURLString,
            defaultBaseURL: URL(string: AppConstants.UnsplashApi.defaultBaseURL)!
        )
    }
}

