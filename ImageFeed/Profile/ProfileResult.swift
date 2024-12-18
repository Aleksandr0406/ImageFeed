//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by 1111 on 11.12.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String?
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImageResult?
}
