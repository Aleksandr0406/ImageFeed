//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by 1111 on 22.01.2025.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var profileImageServiceObserver: NSObjectProtocol?
    var updateProfileCalled: Bool = false
    var updateAvatarPhotoCalled: Bool = false
    var updateAvatarCounter = 0
    
    func updateUserInfo(name: String, login: String, bio: String) {
        updateProfileCalled = true
    }
    
    func updateAvatarPhoto(with imageUrl: URL) {
        updateAvatarPhotoCalled = true
        updateAvatarCounter += 1
    }
}
