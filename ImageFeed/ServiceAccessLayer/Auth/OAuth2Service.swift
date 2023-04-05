//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 24.03.2023.
//

import Foundation

typealias OAuthTokenResponseResult = Result<OAuthTokenResponseBody, Error>
typealias OAuthTokenResponseHandler = (OAuthTokenResponseResult) -> Void

final class OAuth2Service {
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private func buildUrl(for code: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            .init(name: "client_id", value: AppConstants.UnsplashApi.accessKey),
            .init(name: "client_secret", value: AppConstants.UnsplashApi.secretKey),
            .init(name: "redirect_uri", value: AppConstants.UnsplashApi.redirectURI),
            .init(name: "code", value: code),
            .init(name: "grant_type", value: "authorization_code")
        ]

        return urlComponents.url
    }
    
    private func createUrlRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
        
    private func createRequest(code: String) -> URLRequest {
        guard let url = buildUrl(for: code) else {
            fatalError("URL creation failure")
        }
        
        return createUrlRequest(for: url)
    }

    func fetchAuthToken(
        code: String,
        completion: @escaping OAuthTokenResponseHandler
    ) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        let request = createRequest(code: code)
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: OAuthTokenResponseResult) in
            switch result {
            case .success(let responseBody):
                completion(.success(responseBody))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}
