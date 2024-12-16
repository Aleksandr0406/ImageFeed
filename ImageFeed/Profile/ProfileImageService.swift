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
    
    var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(_ username: String, _ token: String, _ urlComponent: String, _ completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let makeRequestToProfileImage = makeRequestToProfileImage(token, urlComponent, username) else {
            print("ProfileImageService: stroke 21 Error make profile request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: makeRequestToProfileImage) { [weak self] (result: Result<ProfileResult, Error>) in
            UIBlockingProgressHUD.dismiss()
            
            guard self != nil else {
                print("ProfileImageService: sroke 29")
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
    
    
    private func makeRequestToProfileImage(_ authToken: String, _ urlComponent: String, _ username: String) -> URLRequest? {
        //guard let url = URL(string: urlComponent + username, relativeTo: Constants.defaultBaseURL) else {
        guard let url = URL(string: "https://api.unsplash.com/users/\(username)") else {
            print("ProfileImageService: stroke 49")
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}


