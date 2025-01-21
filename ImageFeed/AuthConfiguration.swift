//
//  Constants.swift
//  ImageFeed
//
//  Created by 1111 on 19.11.2024.
//

import Foundation

enum Constants {
    static let accessKey = "NeYGLhAO47Ka5EsgFwTqF4dJzNHyRG_RxAWOn1wwT9M"
    static let secretKey = "-KvfMLFNlUlAmhhRPasvWKLA7Z8gECAS-tz3jcfO5TY"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultURL = "https://api.unsplash.com/"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let bearerToken = "AuthToken"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultURL: String
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultURL: String, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultURL = defaultURL
        self.authURLString = authURLString
    }
    
    static var standart: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultURL: Constants.defaultURL,
                                 authURLString: Constants.unsplashAuthorizeURLString)
    }
}
