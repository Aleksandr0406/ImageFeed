//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by 1111 on 22.11.2024.
//

import Foundation
import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        if let baseURL = URL(string: "https://unsplash.com"),
           let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
           ) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            return request
        }
        return URLRequest(url: Constants.defaultBaseURL)
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let makeOAuthTokenRequest = makeOAuthTokenRequest(code: code)
        
        let task = URLSession.shared.data(for: makeOAuthTokenRequest) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(response.access_token))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
