//
//  ImagesListPresenterProtocol.swift
//  ImageFeed
//
//  Created by 1111 on 23.01.2025.
//

import Foundation
import UIKit

public protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func loadNextPhotoPage(completion: @escaping (Result<String, Error>) -> Void)
    func photosCount() -> Int
    func changeLike(for indexPath: IndexPath, completion: @escaping (Result<Bool, Error>) -> Void)
    func likeImage(for indexPath: IndexPath) -> UIImage?
    func saveURLFull(for indexPath: IndexPath)
    func widthCell(for indexPath: IndexPath) -> CGFloat?
    func heightCell(for indexPath: IndexPath) -> CGFloat?
    func urlPhoto(for indexPath: IndexPath) -> URL?
    func createdAt(for indexPath: IndexPath) -> String?
}
