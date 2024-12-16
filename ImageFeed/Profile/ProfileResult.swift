//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by 1111 on 11.12.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String?
    let first_name: String?
    let last_name: String?
    let bio: String?
    let profile_image: ProfileImageResult?
}

//struct Profile {
//    private let username: String
//    private let name: String
//    private let loginName: String
//    private let bio: String
//}
