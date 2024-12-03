//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by 1111 on 28.11.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage: UserDefaults = .standard
    
    var token: String? {
        get { storage.string(forKey: "token") }
        set { storage.set(newValue, forKey: "token") }
    }
}
