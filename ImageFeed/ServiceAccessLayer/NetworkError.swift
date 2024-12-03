//
//  NetworkError.swift
//  ImageFeed
//
//  Created by 1111 on 03.12.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
