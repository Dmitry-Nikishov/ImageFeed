//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.04.2023.
//

import Foundation

typealias ProfileResultErrorResult = Result<ProfileResult, Error>
typealias ProfileErrorResult = Result<Profile, Error>
typealias ProfileServiceResultHandler = (ProfileErrorResult) -> Void

final class ProfileService {
    private var task: URLSessionTask?
    private var lastToken: String?
    
    static let shared = ProfileService()
    
    private init() {}
    
    private(set) var profile: Profile?
    
    private func createUrlComponents() -> URLComponents? {
        var urlComponents = URLComponents(string: AppConstants.UnsplashApi.defaultBaseURL)
        urlComponents?.path = "/me"
        return urlComponents
    }
    
    private func createRequest(_ token: String) -> URLRequest {
        var urlComponents = createUrlComponents()
        guard let url = urlComponents?.url else {
            fatalError("Create URL failure")
        }
        
        var request = URLRequest(url: url)
        request.setValue(
            "Bearer \(token)", forHTTPHeaderField: "Authorization"
        )
        
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping ProfileServiceResultHandler) {
        assert(Thread.isMainThread)
        
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = createRequest(token)
        let session = URLSession.shared
        
        let task = session.objectTask(for: request) { (result: ProfileResultErrorResult) in
            switch result {
            case .success(let response):
                self.profile = Profile(from: response)
                guard let profile = self.profile else {return}
                completion(.success(profile))
                self.profile = profile
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
}
