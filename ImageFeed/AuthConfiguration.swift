//
//  Constants.swift
//  ImageFeed
//
//  Created by 1111 on 19.11.2024.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultURL: String
    let authURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultURL: String,
         authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultURL = defaultURL
        self.authURLString = authURLString
    }
    
    static var standart: AuthConfiguration {
        .init(
            accessKey: Constants.accessKey,
            secretKey: Constants.secretKey,
            redirectURI: Constants.redirectURI,
            accessScope: Constants.accessScope,
            defaultURL: Constants.defaultURL,
            authURLString: Constants.unsplashAuthorizeURLString
        )
    }
}
