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
    private let urlSession: URLSession = URLSession.shared
    
    private func buildUrl(for code: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            .init(name: "client_id", value: App.UnsplashApi.accessKey),
            .init(name: "client_secret", value: App.UnsplashApi.secretKey),
            .init(name: "redirect_uri", value: App.UnsplashApi.redirectURI),
            .init(name: "code", value: code),
            .init(name: "grant_type", value: "authorization_code")
        ]

        return urlComponents.url
    }
    
    private func buildUrlRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    private func buildJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    private func completeOnMainThread(
        handler: @escaping OAuthTokenResponseHandler,
        with arg: OAuthTokenResponseResult
    ) {
        DispatchQueue.main.async {
            handler(arg)
        }
    }
    
    func fetchAuthToken(
        code: String,
        completion: @escaping OAuthTokenResponseHandler
    ) {
        guard let url = buildUrl(for: code) else {
            print("invalid url: \(#function), line: \(#line)")
            return
        }
        
        let request = buildUrlRequest(for: url)
        let decoder = buildJsonDecoder()
        
        urlSession.dataTask(
            with: request,
            completionHandler: { [weak self] data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode > 200 || response.statusCode <= 300 else {
                print("url response status code within (200, 300]: \(#function), line: \(#line)")
                return
            }
                
            do {
                let responseBody = try decoder.decode(
                    OAuthTokenResponseBody.self,
                    from: data
                )
                
                self?.completeOnMainThread(
                    handler: completion,
                    with: .success(responseBody)
                )
            } catch {
                self?.completeOnMainThread(
                    handler: completion,
                    with: .failure(error)
                )
            }
        }).resume()
    }
}