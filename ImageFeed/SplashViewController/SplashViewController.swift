//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by 1111 on 28.11.2024.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

final class SplashViewController: UIViewController {
    private let profileService: ProfileService = .shared
    private let identifierForSegueToAuth = "ShowAuthorization"
    private let alert: AlertPresenter = AlertPresenter()
    private var wasChecked: Bool = false
    private var username: String?
    
    private var imageView: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.delegate = self
        createImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkAuthStatus()
    }
    
    private func checkAuthStatus() {
//        MARK: for testing: removing token from keychain
//        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: Constants.bearerToken)
        
        guard !wasChecked else { return }
        wasChecked = true
        
        if let token = OAuth2TokenStorage.shared.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token)
        } else {
            switchToAuthViewController()
        }
    }
    
    private func createImage() {
        imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchscreenVector")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        self.view.backgroundColor = UIColor(named: "Background")
        
        imageView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func switchToAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return }
        viewController.delegate = self
        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        navigationViewController.modalPresentationStyle = .fullScreen
        present(navigationViewController, animated: true)
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
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        UIBlockingProgressHUD.show()
        
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                guard OAuth2TokenStorage.shared.token != nil else { return }
                
                fetchProfile(token)
            case .failure:
                alert.presentAlert(alert: AlertViewModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    buttonText: "OK")
                )
                break
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        profileService.fetchProfile(token) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let data):
                ProfileService.shared.profile = data
                
                guard let username = data.username else { return }
                fetchProfileImageURL(token, username)
            case .failure:
                alert.presentAlert(alert: AlertViewModel(
                    title: "Что-то пошло не так(",
                    message: "Не удалось войти в систему",
                    buttonText: "OK")
                )
            }
        }
    }
    
    private func fetchProfileImageURL(_ token: String, _ username: String) {
        ProfileImageService.shared.fetchProfileImageURL(username, token) {
            [weak self] (result: Result<ProfileResult, Error>) in
            
            guard let self else { return }
            
            switch result {
            case .success(let data):
                guard let avatarURL = data.profileImage?.large else { return }
                ProfileImageService.shared.avatarURL = avatarURL
                
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
                UIBlockingProgressHUD.dismiss()
                switchToTabBarController()
            case .failure:
                print("SplashViewController: func fetchProfileImageURL(...)/case .failure Error fetch profile image from ProfileImageService")
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
