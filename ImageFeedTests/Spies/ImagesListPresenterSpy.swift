//
//  ImagesListControllerSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 05.05.2023.
//

import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    private var fetchNewPhotosRequestCount = 0
    private var registerNotificationObserverCount = 0
    private var requestChangeLikeCount = 0
    
    var newPhotosRequests: Int {
        return fetchNewPhotosRequestCount
    }
    
    var observerRegistrations: Int {
        return registerNotificationObserverCount
    }
    
    var changeLikes: Int {
        return requestChangeLikeCount
    }
    
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    func fetchNextPagePhotos() {
        fetchNewPhotosRequestCount += 1
    }
    
    func requestChangeLike(photoId: String, isLike: Bool, index: IndexPath) {
        requestChangeLikeCount += 1
    }
    
    func registerNotificationObserver() {
        registerNotificationObserverCount += 1
    }
    
    
}
