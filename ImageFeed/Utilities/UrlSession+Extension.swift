//
//  UrlSession+Extension.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 03.04.2023.
//

import Foundation

private enum NetworkError: Error {
    case urlRequestError(Error)
    case urlSessionError
    case httpStatusCode(Int)
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let handlerOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let result = try decoder.decode(T.self, from: data)
                        handlerOnMainThread(.success(result))
                    } catch {
                        handlerOnMainThread(.failure(NetworkError.urlRequestError(error)))
                    }
                } else {
                    handlerOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                handlerOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                handlerOnMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        return task
    }
}

