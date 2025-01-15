//
//  Photos.swift
//  ImageFeed
//
//  Created by 1111 on 03.01.2025.
//

import Foundation

struct Photo: Decodable {
    let id: String?
    let createdAt: String?
    let width: CGFloat?
    let height: CGFloat?
    let description: String?
    var likedByUser: Bool?
    let urls: UrlsResult?
}

struct IslikedPhotoStats: Decodable {
    let photo: IsLikedPhoto?
}

struct IsLikedPhoto: Decodable {
    let likedByUser: Bool?
}
