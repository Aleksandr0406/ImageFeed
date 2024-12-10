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
            print("Error make profile request")
            return
        }
        
        let task = URLSession.shared.data(for: makeRequestToProfileImage) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ProfileResult.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Error decoding data")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Error receiving data")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func makeRequestToProfileImage(_ authToken: String, _ urlComponent: String, _ username: String) -> URLRequest? {
        guard let url = URL(string: urlComponent + username,relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}

struct UserResult: Codable {
    let small: String?
    let medium: String?
    let large: String?
}
