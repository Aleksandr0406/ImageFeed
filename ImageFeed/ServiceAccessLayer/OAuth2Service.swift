//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by 1111 on 22.11.2024.
//

import Foundation
import UIKit

final class OAuth2Service {
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let makeOAuthTokenRequest = makeOAuthTokenRequest(code: code) else {
            print("Error makeTokenRequest")
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: makeOAuthTokenRequest) { [weak self] (result: Result<OAuthTokenResponseBody, Error>)  in
            //            switch result {
            //            case .success(let data):
            //                do {
            //                    let decoder = JSONDecoder()
            //                    decoder.keyDecodingStrategy = .convertFromSnakeCase
            //                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
            //                    completion(.success(response.accessToken))
            //                } catch {
            //                    print("Error decoding data")
            //                    completion(.failure(error))
            //                }
            //            case .failure(let error):
            //                print("Error receiving data")
            //                completion(.failure(error))
            //            }
            guard self != nil else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let response):
                //storage.token = response.accessToken
                let token = response.accessToken
                completion(.success(token))
            case .failure:
                print("Error fetch token in task")
                break
            }
        }
        self.task = nil
        self.lastCode = nil
        
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com"),
              let url = URL(
                string: "/oauth/token"
                + "?client_id=\(Constants.accessKey)"
                + "&&client_secret=\(Constants.secretKey)"
                + "&&redirect_uri=\(Constants.redirectURI)"
                + "&&code=\(code)"
                + "&&grant_type=authorization_code",
                relativeTo: baseURL
              ) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
