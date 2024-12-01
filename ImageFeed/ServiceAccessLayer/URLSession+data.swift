//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by 1111 on 26.11.2024.
//

import Foundation

extension URLSession {
    func data(
        for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
            let fulfillCompletionOnMainThread: (Result<Data, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            let task = dataTask(with: request, completionHandler: { data, response, error in
                if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if 200..<300 ~= statusCode {
                        fulfillCompletionOnMainThread(.success(data))
                    } else {
                        print("NetworkError StatusCode")
                        fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    print("NetworkError urlRequestError")
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                } else {
                    print("NetworkError urlSessionError")
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                }
            })
            
            return task
        }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
