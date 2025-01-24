//
//  WebViewViewControllerProtocol.swift
//  ImageFeed
//
//  Created by 1111 on 17.01.2025.
//

import Foundation

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}
