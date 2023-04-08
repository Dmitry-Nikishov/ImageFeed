//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.04.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}
