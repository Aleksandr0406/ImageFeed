//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by 1111 on 03.01.2025.
//

import Foundation

final class ImagesListService {
    static let shared = ImagesListService()
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
//    private(set) var photos: [Photo] = []
    
    private let storageToken = OAuth2TokenStorage.shared.token
    
    private var nextPageNumber: Int = 1
    
    private var task: URLSessionTask?
    
    private init() {}
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
//        let nextPage = (lastLoadedPage?.number ?? 0) + 1
        guard let token = storageToken else { return }
        fetchPhotos(token) { [weak self] (result: Result<[Photo], Error>) in
            guard self != nil else {
                print("ImagesListService: func fetchPhotosNextPage(...)/guard let self")
                return
            }
            
            switch result {
            case .success(let data):
                print("Good")
                print(data.count)
                completion(.success(data))
            case .failure:
                print("ImagesListService: func fetchPhotosNextPage(...)/case .failure")
            }
        }
    }
    
    private func fetchPhotos(_ token: String, completion: @escaping (Result<[Photo], Error>) -> Void) {
        nextPageNumber += 1
        task?.cancel()
        
        guard let makeRequestToPhotos = makeRequestToPhotos(token) else {
            print("ProfileService: func fetchProfile(...)/makeRequestToProfile Error make profile request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: makeRequestToPhotos) { [weak self] (result: Result<[Photo], Error>) in
            UIBlockingProgressHUD.dismiss()
            
            guard self != nil else {
                print("ImagesListService: func fetchPhotos(...)/URLSession.shared.objectTask")
                return
            }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("Error pushing data in ImagesListService")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func makeRequestToPhotos(_ authToken: String) -> URLRequest? {
        guard var urlComponent = URLComponents(string: Constants.defaultURL + "photos") else { return nil }
        urlComponent.queryItems = [
            URLQueryItem(name: "page", value: nextPageNumber.description)
        ]
        guard let url = urlComponent.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        return request
    }
}
