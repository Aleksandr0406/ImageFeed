//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by 1111 on 22.01.2025.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() -> String? {
        viewDidLoadCalled = true
        return ""
    }
    
    func loadUrlAvatarPhoto() -> URL? {
        return nil
    }
    
    func logOut() {}
}
