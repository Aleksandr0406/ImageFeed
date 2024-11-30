//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by 1111 on 26.11.2024.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let access_token: String
    let token_type: String
    let scope: String
    let created_at: Int
}
