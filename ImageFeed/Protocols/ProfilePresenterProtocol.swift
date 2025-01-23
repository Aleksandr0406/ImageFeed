//
//  ProfilePresenterProtocol.swift
//  ImageFeed
//
//  Created by 1111 on 21.01.2025.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad() -> String?
    func logOut()
}
