//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by 1111 on 17.01.2025.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}
