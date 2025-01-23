//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by 1111 on 17.01.2025.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell, complition: @escaping (Result<Bool, Error>) -> Void)
}
