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
    
    private init() {}
    
    func fetchProfile(_ token: String, _ urlComponent: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let makeRequestToProfile = makeRequestToProfile(token, urlComponent) else {
            print("ProfileService: stroke 20 Error make profile request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: makeRequestToProfile) { [weak self] (result: Result<ProfileResult, Error>) in
            UIBlockingProgressHUD.dismiss()
            
            guard self != nil else {
                print("ProfileService: stroke 28")
                return
            }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                print("Error pushing data in ProfileService")
                break
            }
        }
        
        task.resume()
    }
    
    private func makeRequestToProfile(_ authToken: String, _ urlComponent: String) -> URLRequest? {
        guard let url = URL(
            string: urlComponent,
            relativeTo: Constants.defaultBaseURL
        ) else {
            print("ProfileService: stroke 46-48")
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}


