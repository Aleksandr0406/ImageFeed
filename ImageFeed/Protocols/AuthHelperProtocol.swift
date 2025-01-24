//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by 1111 on 17.01.2025.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
