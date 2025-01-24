//
//  ProfileService.swift
//  ImageFeed
//
//  Created by 1111 on 05.12.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    var profile: ProfileResult?
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        task?.cancel()
        
        guard let requestToProfile = makeRequestToProfile(token) else { return }
        
        let task = URLSession.shared.objectTask(for: requestToProfile) { [weak self] (result: Result<ProfileResult, Error>) in
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("Error pushing data in ProfileService")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func makeRequestToProfile(_ authToken: String) -> URLRequest? {
        guard let url = URL(string: Constants.defaultURL + "me") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}


