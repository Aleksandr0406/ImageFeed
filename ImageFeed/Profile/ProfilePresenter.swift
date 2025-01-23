//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by 1111 on 21.01.2025.
//

import Foundation
import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() -> String? {
        guard
            let profileFirstName = ProfileService.shared.profile?.firstName,
            let profileUsername = ProfileService.shared.profile?.username
        else { return nil }
        
        guard let profileBio = ProfileService.shared.profile?.bio else { return "" }
        
        view?.updateUserInfo(name: profileFirstName, login: profileUsername, bio: profileBio)
        view?.profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                print(">>> [ProfileViewController] Notification received, updating avatar")
                self.updateAvatar()
            }
        updateAvatar()
        
        return ""
    }
    
    func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageURL = URL(string: profileImageURL)
        else { return }
        view?.updateAvatarPhoto(with: imageURL)
    }
    
    func logOut() {
        ProfileLogoutService.shared.logout()
    }
}
