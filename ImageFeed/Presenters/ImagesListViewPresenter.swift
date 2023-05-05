//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 05.05.2023.
//

import Foundation

public protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? {get set}
    
    func fetchNextPagePhotos()
    func requestChangeLike(
        photoId: String,
        isLike: Bool,
        index: IndexPath
    )
    func registerNotificationObserver()
}


final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService.shared
    
    weak var view: ImagesListViewControllerProtocol?
    
    func fetchNextPagePhotos() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func requestChangeLike(
        photoId: String,
        isLike: Bool,
        index: IndexPath
    ) {
        imagesListService.changeLike(photoId: photoId, isLike: isLike) {
            [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success:
                self.view?.handleSuccessfullChangeLike(
                    photos: self.imagesListService.photos,
                    index: index
                )

            case .failure(let error):
                self.view?.handleFailureChangeLike(failureReason: error)
            }
        }
    }
    
    func registerNotificationObserver() {
        imagesListServiceObserver = NotificationCenter
            .default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }

                self.view?.updateAnimated(
                    with: self.imagesListService.photos
                )
            }
    }
}
