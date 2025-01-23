//
//  ImagesListViewControllerProtocol.swift
//  ImageFeed
//
//  Created by 1111 on 23.01.2025.
//

import Foundation

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
}
