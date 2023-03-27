//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 24.03.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
