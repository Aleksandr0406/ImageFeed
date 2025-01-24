//
//  ImagesListPresenterMock.swift
//  ImageFeedTests
//
//  Created by 1111 on 23.01.2025.
//

@testable import ImageFeed
import Foundation
import UIKit

final class ImagesListPresenterMock: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    
    func loadNextPhotoPage(completion: @escaping (Result<String, any Error>) -> Void) {}
    
    func likeImage(for indexPath: IndexPath) -> UIImage? { nil }
    
    func saveURLFull(for indexPath: IndexPath) {
        guard let urlFull = photos[indexPath.row].urls?.full  else { return }
    }
    
    func widthCell(for indexPath: IndexPath) -> CGFloat? {
        guard let width = photos[indexPath.row].width else { return nil }
        return width
    }
    
    func heightCell(for indexPath: IndexPath) -> CGFloat? {
        guard let height = photos[indexPath.row].height else { return nil }
        return height
    }
    
    func urlPhoto(for indexPath: IndexPath) -> URL? {
        guard let urlRegular = photos[indexPath.row].urls?.regular else { return nil }
        return urlRegular
    }
    
    func createdAt(for indexPath: IndexPath) -> String? {
        guard let createdAt = photos[indexPath.row].createdAt else { return nil }
        return createdAt
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func changeLike(for indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void) {
        let photo = photos[indexPath.row]
        let newPhoto = Photo(id: photo.id, createdAt: photo.createdAt, width: photo.width, height: photo.height, description: photo.description, likedByUser: !photo.likedByUser!, urls: photo.urls)
        photos[indexPath.row] = newPhoto
        guard let likedByUser = photos[indexPath.row].likedByUser else { return }
        completion(.success(likedByUser))
    }
}
