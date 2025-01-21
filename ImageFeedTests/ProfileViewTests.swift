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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewcontroller = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        let presenter = WebViewPresenterSpy()
        viewcontroller.presenter = presenter
        presenter.view = viewcontroller
        
        _ = viewcontroller.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewcontrollerCallsUpdateAvatar() {
        let viewController = WebViewViewControllerSpy()
        let auhtHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: auhtHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssert(viewController.loadRequestCalled)
    }
}
