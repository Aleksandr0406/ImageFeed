//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by 1111 on 06.12.2024.
//

import Foundation

final class ProfileImageService {
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProvideDidChange")
    static let shared = ProfileImageService()
    
    private var task: URLSessionTask?
    
    var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(_ username: String, _ token: String, _ completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        task?.cancel()
        
        guard let makeRequestToProfileImage = makeRequestToProfileImage(token, username) else {
            print("ProfileImageService: func fetchProfileImageURL(...)/makeRequestToProfileImage Error make profile request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: makeRequestToProfileImage) { [weak self] (result: Result<ProfileResult, Error>) in
            UIBlockingProgressHUD.dismiss()
            
            guard self != nil else {
                print("ProfileImageService: func fetchProfileImageURL/URLSession.shared.objectTask")
                return
            }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                print("Error pushing data in ProfileImageService")
                break
            }
        }
        
        task.resume()
    }
    
    
    private func makeRequestToProfileImage(_ authToken: String, _ username: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("ProfileImageService: func makeRequestToProfileImage(...)")
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}


