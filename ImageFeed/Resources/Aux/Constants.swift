//
//  Constants.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 21.03.2023.
//

import Foundation

enum AppConstants {
    enum UnsplashApi {
        static let accessKey = "YCx4-W7k2UhrDesFH23pElxqIP0qe1NiU4hW1NSjGtU"
        static let secretKey = "M75wixC1xEphJbRvyqFLjRdp8JjujkB5kX30hfa-yAs"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseURL = "https://api.unsplash.com"
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
}

