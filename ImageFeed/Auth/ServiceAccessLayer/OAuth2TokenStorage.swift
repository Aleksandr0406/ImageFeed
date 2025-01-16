//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by 1111 on 18.12.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: Constants.bearerToken)
        }
        set {
            guard let newValue = newValue else { return }
            keychainWrapper.set(newValue, forKey: Constants.bearerToken)
        }
    }
    
    private let keychainWrapper = KeychainWrapper.standard
    
    private init() {}
}
