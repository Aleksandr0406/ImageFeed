//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by 1111 on 28.11.2024.
//

import Foundation

protocol AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
