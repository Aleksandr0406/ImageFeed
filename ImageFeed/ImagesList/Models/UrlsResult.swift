//
//  UrlsResult.swift
//  ImageFeed
//
//  Created by 1111 on 03.01.2025.
//

import Foundation

struct UrlsResult: Decodable {
    let raw: URL?
    let full: URL?
    let regular: URL?
    let small: URL?
    let thumb: URL?
}
