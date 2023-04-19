//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 14.04.2023.
//

import Foundation

typealias PhotoResultOrError = Result<[PhotoResult], Error>
typealias LikeCompletionResult = Result<Void, Error>

final class ImagesListService {
    static let shared = ImagesListService()
    
    private var lastLoadedPage: Int = 1
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")

    private (set) var photos: [Photo] = []
    
    private init() {}
    
    private func createUrl(for page: Int) -> URL? {
        var urlComponents = URLComponents(
            string: AppConstants.UnsplashApi.defaultBaseURL
        )
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [.init(name: "page", value: "\(page)")]

        return urlComponents?.url
    }
    
    private func createRequestObject(token: String, url: URL) -> URLRequest? {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func createPhotosRequest(for page: Int) -> URLRequest? {
        guard let token = oAuth2TokenStorage.token else {
            assertionFailure("Access token creation failure")
            return nil
        }

        guard let url = createUrl(for: page) else {
            assertionFailure("URL creation failure")
            return nil
        }
        
        return createRequestObject(token: token, url: url)
    }

    private func notifyPhotosChange() {
        NotificationCenter
            .default
            .post(
                name: ImagesListService.didChangeNotification,
                object: self,
                userInfo: ["photos": self.photos]
            )
    }
    
    private func createLikeUrl(for id: String) -> URL? {
        var urlComponents = URLComponents(
            string: AppConstants.UnsplashApi.defaultBaseURL
        )
        urlComponents?.path = "/photos/\(id)/like"
        
        return urlComponents?.url
    }
    
    private func createLikeUrlRequest(
        url: URL,
        isLike: Bool,
        token: String
    ) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    private func createLikeRequest(_ id: String, isLike: Bool) -> URLRequest? {
        guard let token = oAuth2TokenStorage.token else {
            assertionFailure("Error creating access token")
            return nil
        }

        guard let url = createLikeUrl(for: id) else {
            assertionFailure("Error creating like URL")
            return nil
        }
        
        return createLikeUrlRequest(
            url: url,
            isLike: isLike,
            token: token
        )
    }

    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil {
            return
        }
        task?.cancel()
        
        guard let requestPhotoPerPage = createPhotosRequest(
            for: lastLoadedPage
        ) else {
            return assertionFailure("Request photo error")
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: requestPhotoPerPage) {
            [weak self] (result: PhotoResultOrError) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let photoResult):
                photoResult.forEach {
                    self.photos.append(Photo(from: $0))
                }
                
                self.lastLoadedPage += 1
                self.notifyPhotosChange()
            case .failure(let error):
                assertionFailure("fetchPhotosNextPage error : \(error)")
            }
            
            self.task = nil
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(
        photoId: String,
        isLike: Bool,
        completion: @escaping (LikeCompletionResult) -> Void
    ) {
        assert(Thread.isMainThread)
        if likeTask != nil {
            return
        }
        likeTask?.cancel()

        let session = URLSession.shared
        guard let likeRequest = createLikeRequest(photoId, isLike: isLike) else {
            return assertionFailure("Error creating like request")
        }

        let task = session.objectTask(for: likeRequest) {
            [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else {
                return
            }
            
            self.likeTask = nil
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let photoResult):
                let newPhotoItem = LikedPhoto(likedPhotoResult: photoResult)
                if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                    var photo = self.photos[index]
                    photo.isLiked = newPhotoItem.likedPhoto.likedByUser
                    self.photos[index] = photo
                }
                completion(.success(()))
            }
        }
        self.likeTask = task
        task.resume()
    }
}
