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
    
    private let storageToken = OAuth2TokenStorage.shared.token
    private var task: URLSessionTask?
    
    var photos: [Photo] = []
    var nextPageNumber: Int = 1
    
    private init() {}
    
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let token = storageToken else { return }
        fetchPhotos(token) { [weak self] (result: Result<[Photo], Error>) in
            guard self != nil else {
                print("ImagesListService: func fetchPhotosNextPage(...)/guard let self")
                return
            }
            
            switch result {
            case .success(let data):
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
    
    func fetchIsLiked(tokenIn token: String, idIn id: String, requestTypeIn requestType: String, completion: @escaping (Result<IslikedPhotoStats, Error>) -> Void) {
        task?.cancel()
        
        guard let makeRequestToIsLiked = makeRequestToIsLiked(tokenIn: token, idIn: id, requestTypein: requestType) else {
            print("ProfileService: func fetchProfile(...)/makeRequestToProfile Error make profile request")
            return
        }
        
        let task = URLSession.shared.objectTask(for: makeRequestToIsLiked) { [weak self] (result: Result<IslikedPhotoStats, Error>) in
            UIBlockingProgressHUD.dismiss()
            
            guard self != nil else {
                print("ImagesListService: URLSession.shared.objectTask/ guard self")
                return
            }
            
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure:
                print("ImagesListService: URLSession.shared.objectTask/ case .failure")
            }
        }
        
        task.resume()
    }
    
    private func makeRequestToIsLiked(tokenIn token: String, idIn id: String, requestTypein requestType: String) -> URLRequest? {
        guard let urlComponent = URLComponents(string: Constants.defaultURL + "photos/" + id + "/like") else { return nil }
        
        guard let url = urlComponent.url else { return nil }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = requestType
        return request
    }
}
