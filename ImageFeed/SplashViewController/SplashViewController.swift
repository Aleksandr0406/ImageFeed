//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by 1111 on 28.11.2024.
//

import Foundation
import UIKit
import ProgressHUD
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let identifierForSegueToAuth = "ShowAuthorization"
    private var username: String?
    
    //private let storage: String?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let tokenTestFetchFromKeychain: String = KeychainWrapper.standard.string(forKey: "Auth token") {
           //let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "Auth token") 
            //guard let token = tokenTestFetchFromKeychain else { return }
            
            fetchProfile(tokenTestFetchFromKeychain)
        } else {
            performSegue(withIdentifier: identifierForSegueToAuth, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            print("SplashViewController: stroke 34")
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
                print("SplashViewController: stroke 55-56")
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
            guard let self else {
                print("SplashViewController: stroke 73")
                return
            }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self else {
                print("SplashViewController: stroke 83")
                return
            }
            
            switch result {
            case .success(let token):
                //storage.token = token
                let token = token
                let isSuccess = KeychainWrapper.standard.set(token, forKey: "Auth token")
                guard isSuccess else {
                    print("SplashViewController: stroke 93 Cant save token in keychain")
                    return
                }
                //let tokenTestFetchFromKeychain: String? = KeychainWrapper.standard.string(forKey: "Auth token")
                
                fetchProfile(token)
            case .failure:
                print("SplashViewController: stroke 100 Error fetch data token from OAuth2Service")
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token, Constants.urlComponentToBaseProfile) { [weak self] (result: Result<ProfileResult, Error>) in
            //UIBlockingProgressHUD.dismiss()
            
            guard let self else {
                print("SplashViewController: stroke 112")
                return
            }
            
            switch result {
            case .success(let data):
                ProfileService.shared.profile = data
//                print(data.first_name!)
//                print(data.username!)
//                print(data.bio!)

                guard let username = data.username else {
                    print("SplashViewController: stroke 124")
                    return
                }
                print(username)
                fetchProfileImageURL(token, username)
                //switchToTabBarController()
            case .failure:
                print("SplashViewController: stroke 131 Error fetch data profile from ProfileService")
                break
            }
        }
    }
    
    private func fetchProfileImageURL(_ token: String, _ username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username, token, Constants.urlComponentToPublicProfile) {
            [weak self] (result: Result<ProfileResult, Error>) in
            //UIBlockingProgressHUD.dismiss()
            
            guard let self else {
                print("SplashViewController: stroke 143")
                return
            }
            
            switch result {
            case .success(let data):
                guard let avatarURL = data.profile_image?.large else {
                    print("SplashViewController: stroke 150")
                    return
                }
                ProfileImageService.shared.avatarURL = avatarURL
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": ProfileImageService.shared.avatarURL!])
                
                switchToTabBarController()
            case .failure:
                print("SplashViewController: stroke 163 Error fetch profile image from ProfileImageService")
                break
            }
        }
    }
}
