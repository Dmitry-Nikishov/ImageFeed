//
//  PhotoHelpers.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 05.05.2023.
//

import Foundation

final class PhotoHelpers {
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()
    
    static func getCreatedDate(for photo: Photo) -> String {
        var formattedDate: String = ""
        if let dateString = photo.createdAt {
            formattedDate = dateFormatter.string(from: dateString)
        }
        
        return formattedDate
    }
}
