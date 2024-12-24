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
                        print("URLSession: NetworkError StatusCode:", statusCode)
                        fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    print("URLSession: NetworkError urlRequestError")
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                } else {
                    print("URLSession: NetworkError urlSessionError")
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                }
            })
            
            return task
        }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let response = try decoder.decode(T.self, from: data)
                    completion(.success(response))
                } catch {
                    print("URLSession: catch Error decoding data in func objectTask: \(error.localizedDescription), data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("URLSession: Error receiving data in func objectTask")
                completion(.failure(error))
            }
        }
        
        return task
    }
}
