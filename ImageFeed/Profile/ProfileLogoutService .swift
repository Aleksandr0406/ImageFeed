//
//  ProfileLogoutService .swift
//  ImageFeed
//
//  Created by 1111 on 13.01.2025.
//

import Foundation
import WebKit
import SwiftKeychainWrapper

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private var removeSuccessful = KeychainWrapper.standard
    private var profileService: ProfileService = .shared
    private var profileImageService: ProfileImageService = .shared
    private var imageListService: ImagesListService = .shared
    
    private init() {}
    
    func logout() {
        cleanCookies()
        profileService.profile = nil
        profileImageService.avatarURL = nil
        imageListService.photos = []
        imageListService.nextPageNumber = 1
        removeSuccessful.removeObject(forKey: Constants.bearerToken)
        switchToAuthViewController()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func switchToAuthViewController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}
