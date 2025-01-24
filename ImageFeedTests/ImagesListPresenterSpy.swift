//
//  ImageListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by 1111 on 23.01.2025.
//
import ImageFeed
import Foundation
import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var loadNextPhotoPageCalled: Bool = false
    
    func loadNextPhotoPage(completion: @escaping (Result<String, Error>) -> Void) {
        loadNextPhotoPageCalled = true
    }
    func likeImage(for indexPath: IndexPath) -> UIImage? { nil }
    func saveURLFull(for indexPath: IndexPath) {}
    func widthCell(for indexPath: IndexPath) -> CGFloat? { nil }
    func heightCell(for indexPath: IndexPath) -> CGFloat? { nil }
    func urlPhoto(for indexPath: IndexPath) -> URL? { nil }
    func createdAt(for indexPath: IndexPath) -> String? { nil }
    func photosCount() -> Int { 0 }
    func changeLike(for indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void) {}
}
