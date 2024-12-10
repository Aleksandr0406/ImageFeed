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
            print("Error make profile request")
            return
        }
        
        let task = URLSession.shared.data(for: makeRequestToProfile) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    //decoder.keyDecodingStrategy = .convertFromSnakeCase
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
    
    private func makeRequestToProfile(_ authToken: String, _ urlComponent: String) -> URLRequest? {
        guard let url = URL(
            string: urlComponent,
            relativeTo: Constants.defaultBaseURL
        ) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}

struct ProfileResult: Codable {
    let username: String?
    let first_name: String?
    let last_name: String?
    let bio: String?
    let profile_Image: UserResult?
}

//struct Profile {
//    private let username: String
//    private let name: String
//    private let loginName: String
//    private let bio: String
//}

