//
//  ImagesListTypes.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 19.04.2023.
//

import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

enum FeedCellImageState {
    case loading
    case error
    case finished(UIImage, String, Bool)
}
