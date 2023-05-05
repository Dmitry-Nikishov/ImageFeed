//
//  Photo.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 14.04.2023.
//

import Foundation

public struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = result.likedByUser
    }
    
    static func getDummy(with date: Date) -> Photo {
        let photo = PhotoResult(
            id: "",
            createdAt: date,
            width: 0,
            height: 0,
            description: "",
            likedByUser: true,
            urls: UrlsResult(full: "", thumb: "")
        )
        return Photo(from: photo)
    }
}

struct LikedPhoto {
    let likedPhoto: PhotoResult
    
    init(likedPhotoResult: LikePhotoResult) {
        self.likedPhoto = likedPhotoResult.photo
    }
}
