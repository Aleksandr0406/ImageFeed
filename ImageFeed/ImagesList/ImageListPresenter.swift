//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by 1111 on 22.01.2025.
//

import Foundation

import Foundation
import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    static var urlFull: URL?
    
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    private let service = ImagesListService.shared
    private var dateFormatterISO = ISO8601DateFormatter()
    private var dateFormatter = DateFormatter()
    
    func loadNextPhotoPage(completion: @escaping (Result<String, Error>) -> Void) {
        service.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPhoto):
                photos += newPhoto
                service.photos += newPhoto
                completion(.success("Good"))
            case .failure:
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func changeLike(for indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void) {
        let photo = photos[indexPath.row]
        
        guard let id = photo.id,
              let likedByUser = photo.likedByUser,
              let token = OAuth2TokenStorage.shared.token else { return }
        
        service.setLikeState(likedByUser, token, id) { [weak self] (result: Result<IslikedPhotoStats, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                self.photos[indexPath.row].likedByUser = !likedByUser
                guard let isLiked = data.photo?.likedByUser else { return }
                completion(.success(isLiked))
            case .failure:
                print("ImagesListViewController: func imageListCellDidTapLike/ .failure")
            }
        }
    }
    
    func likeImage(for indexPath: IndexPath) -> UIImage? {
        guard let isLiked = photos[indexPath.row].likedByUser else { return nil }
        
        let likeImage = isLiked ? UIImage(named: "Like_button_on") : UIImage(named: "Like_button_off")
        return likeImage
    }
    
    func saveURLFull(for indexPath: IndexPath) {
        ImagesListPresenter.urlFull = photos[indexPath.row].urls?.full
    }
    
    func widthCell(for indexPath: IndexPath) -> CGFloat? {
        guard let imageWidth = photos[indexPath.row].width else { return nil }
        return imageWidth
    }
    
    func heightCell(for indexPath: IndexPath) -> CGFloat? {
        guard let imageHeight = photos[indexPath.row].height else { return nil }
        return imageHeight
    }
    
    func urlPhoto(for indexPath: IndexPath) -> URL? {
        return photos[indexPath.row].urls?.regular
    }
    
    func createdAt(for indexPath: IndexPath) -> String? {
        guard let createdAt = photos[indexPath.row].createdAt else { return nil }
        return createdAt
    }
}

