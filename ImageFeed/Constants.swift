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
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com/")!
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}