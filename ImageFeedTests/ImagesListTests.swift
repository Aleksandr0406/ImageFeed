//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by 1111 on 23.01.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsloadNextPhotoPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.loadNextPhotoPageCalled)
    }
    
    func testPresenterReturnsPhotoInfo() {
        let presenter = ImagesListPresenterFake()
        let photo = Photo(
            id: "id",
            createdAt: "01.01.01",
            width: 300,
            height: 400,
            description: "description",
            likedByUser: true,
            urls: UrlsResult(raw: URL(string: "https://full.com"), full: URL(string: "https://full.com"), regular: URL(string: "https://regular.com"), small: URL(string: "https://small.com"), thumb: URL(string: "https://thumb.com"))
        )
        let indexPath = IndexPath(row: 0, section: 0)
        
        presenter.photos = [photo]
        
        XCTAssertEqual(presenter.photosCount(), 1)
        XCTAssertEqual(presenter.urlPhoto(for: indexPath), photo.urls?.regular)
        XCTAssertEqual(presenter.createdAt(for: indexPath), photo.createdAt)
        XCTAssertEqual(presenter.widthCell(for: indexPath), photo.width)
        XCTAssertEqual(presenter.heightCell(for: indexPath), photo.height)
    }
    
    func testPresenterChangeLike() {
        let presenter = ImagesListPresenterFake()
        let photo = Photo(
            id: "id",
            createdAt: "01.01.01",
            width: 300,
            height: 400,
            description: "description",
            likedByUser: true,
            urls: UrlsResult(raw: URL(string: "https://full.com"), full: URL(string: "https://full.com"), regular: URL(string: "https://regular.com"), small: URL(string: "https://small.com"), thumb: URL(string: "https://thumb.com"))
        )
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.photos = [photo]
        
        let expectation = XCTestExpectation()
        presenter.changeLike(for: indexPath) { _ in
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(presenter.photos[indexPath.row].likedByUser, false)
    }
}

