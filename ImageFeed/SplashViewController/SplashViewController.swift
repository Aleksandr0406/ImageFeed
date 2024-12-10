//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by 1111 on 28.11.2024.
//

import Foundation
import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let identifierForSegueToAuth = "ShowAuthorization"
    
    private let storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            guard let token = storage.token else { return }
            
            fetchProfile(token)
            //fetchProfileImageURL(token)
        } else {
            performSegue(withIdentifier: identifierForSegueToAuth, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifierForSegueToAuth {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(identifierForSegueToAuth)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            //            guard let self else { return }
            //
            //            UIBlockingProgressHUD.dismiss()
            //
            //            switch result {
            //            case .success(let data):
            //                storage.token = data
            //                guard let token = storage.token else { return }
            //                self.fetchProfile(token)
            //            case .failure:
            //                print("Error fetch token")
            //                break
            //            }
            guard let self else { return }
            
            switch result {
            case .success(let token):
                storage.token = token
                fetchProfile(token)
            case .failure:
                print("Error fetch token")
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token, Constants.urlComponentToBaseProfile) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let response):
                profileService.profile = response
                guard let username = response.username else { return }
                self.fetchProfileImageURL(token, username)
                self.switchToTabBarController()
            case .failure:
                print("Error fetch token")
                break
            }
        }
    }
    
    private func fetchProfileImageURL(_ token: String, _ username: String) {
        ProfileImageService.shared.fetchProfileImageURL(token, Constants.urlComponentToPublicProfile, username) {
            [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                guard let avatarURL = data.profile_Image?.small else { return }
                ProfileImageService.shared.avatarURL = avatarURL
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
            case .failure:
                print("Error fetch token")
                break
            }
        }
    }
}
