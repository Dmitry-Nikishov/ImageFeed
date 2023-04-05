//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.04.2023.
//

import Foundation

typealias ProfileUserResult = Result<UserResult, Error>
typealias ProfileImageResultHandler = (Result<String, Error>) -> Void

final class ProfileImageServices {
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    static let shared = ProfileImageServices()
    
    private init() {}
    
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private func createUrlComponents(for username: String) -> URLComponents? {
        var urlComponents = URLComponents(string: AppConstants.UnsplashApi.defaultBaseURL)
        urlComponents?.path = "/users/\(username)"
        return urlComponents
    }
    
    private func createRequest(_ username: String) -> URLRequest {
        let urlComponents = createUrlComponents(for: username)
        guard let url = urlComponents?.url else {
            fatalError("URL creation failure")
        }
        
        var request = URLRequest(url: url)
        guard let token = OAuth2TokenStorage().token else {
            fatalError("Token creation failure")
        }
        
        request.setValue(
            "Bearer \(token)", forHTTPHeaderField: "Authorization"
        )
        return request
    }

    private func notifyChange(_ imageURL: String) {
        NotificationCenter
            .default
            .post(
                name: ProfileImageServices.didChangeNotification,
                object: self,
                userInfo: ["URL": imageURL]
            )
    }
    
    private func createDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping ProfileImageResultHandler) {
        assert(Thread.isMainThread)
        
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        
        let request = createRequest(username)
        let decoder = createDecoder()
        
        let session: URLSession = URLSession.shared
        let task = session.objectTask(for: request) { (result: ProfileUserResult) in
            switch result {
            case .success(let responseBody):
                let profileImageURL = responseBody.profileImage.small
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                self.notifyChange(profileImageURL)
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastUsername = nil
            }
        }
        self.task = task
        task.resume()
    }
    
}
