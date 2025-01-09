//
//  Photos.swift
//  ImageFeed
//
//  Created by 1111 on 03.01.2025.
//

import Foundation

struct Photo: Decodable {
    let id: String?
//    let size: CGSize?
    let createdAt: String?
    let description: String?
//    let thumbImageURL: String?
//    let largeImageURL: String?
    let likedByUser: Bool?
    let urls: UrlsResult?
}
