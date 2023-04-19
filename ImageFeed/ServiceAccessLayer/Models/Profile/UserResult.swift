//
//  UserResult.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.04.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Decodable {
        let small: String
    }
}
