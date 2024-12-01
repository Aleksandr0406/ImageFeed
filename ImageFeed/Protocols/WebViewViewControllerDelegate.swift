//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by 1111 on 21.11.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
