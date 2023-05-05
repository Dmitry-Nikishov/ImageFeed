//
//  PlaceholderImageCreator.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 05.05.2023.
//

import UIKit

final class PlaceholderImageCreator {
    static func create(name: String, size: CGFloat) -> UIImage? {
        let placeholderImageConfig = UIImage.SymbolConfiguration(pointSize: size)
        
        let placeholderImage = UIImage(
            systemName: name,
            withConfiguration: placeholderImageConfig
        )
        placeholderImage?.withTintColor(
            .gray,
            renderingMode: .alwaysOriginal
        )
        
        return placeholderImage
    }
}
