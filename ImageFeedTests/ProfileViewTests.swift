//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by 1111 on 20.01.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdatingProfile() {
        let viewController = ProfileViewControllerSpy()
        let profile = ProfileResult(username: "Sasha", firstName: "Aleksandr", lastName: "Aleksandr", bio: "Hello", profileImage: nil)
        let avatarPhotoURL = "https://www.placebear.com/200/300"
        ProfileService.shared.profile = profile
        ProfileImageService.shared.avatarURL = avatarPhotoURL
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController

        presenter.viewDidLoad()
        
        XCTAssertTrue(viewController.updateProfileCalled)
        XCTAssertTrue(viewController.updateAvatarPhotoCalled)
    }
    
    func testUpdatingAvatarPhotoByNotification() {
        let viewController = ProfileViewControllerSpy()
        let profile = ProfileResult(username: "Sasha", firstName: "Aleksandr", lastName: "Aleksandr", bio: "Hello", profileImage: nil)
        let avatarPhotoURL = "https://www.placebear.com/200/300"
        ProfileService.shared.profile = profile
        ProfileImageService.shared.avatarURL = avatarPhotoURL
        let presenter = ProfilePresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        NotificationCenter.default.post(
            name: ProfileImageService.didChangeNotification,
            object: nil
        )

        XCTAssertEqual(viewController.updateAvatarCounter, 2)
    }
}
