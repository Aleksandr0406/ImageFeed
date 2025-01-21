//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by 1111 on 21.01.2025.
//

import Foundation

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    var profileImageServiceObserver: NSObjectProtocol? { get set }
    func updateUserInfo(name: String, login: String, bio: String)
    func updateAvatarPhoto(with imageUrl: URL)
}
