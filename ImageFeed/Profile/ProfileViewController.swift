//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by 1111 on 31.10.2024.
//

import Foundation
import UIKit
import Kingfisher

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol? = ProfilePresenter()
    var profileImageServiceObserver: NSObjectProtocol?
    
    private lazy var avatarPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var profileName: UILabel = UILabel()
    private var mailProfile: UILabel = UILabel()
    private var descriptionProfile: UILabel = UILabel()
    private var exitButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "Background")
        
        createProfileImage()
        createProfileName()
        createMailProfile()
        createDescriptionProfile()
        createExitButton()
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        avatarPhoto.layer.cornerRadius = avatarPhoto.frame.width
    }
    
    func updateUserInfo(name: String, login: String, bio: String) {
        profileName.text = name
        mailProfile.text = login
        descriptionProfile.text = bio
    }
    
    func updateAvatarPhoto(with imageUrl: URL) {
        avatarPhoto.kf.indicatorType = .activity
        let processor = DownsamplingImageProcessor(size: avatarPhoto.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 61)
        avatarPhoto.kf.setImage(
            with: imageUrl,
            placeholder: UIImage(named: "Placeholder"),
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    private func createProfileImage() {
        avatarPhoto = UIImageView()
        avatarPhoto.image = UIImage(named: "AlternativeAvatarPhoto")
        
        avatarPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(avatarPhoto)
        
        avatarPhoto.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarPhoto.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarPhoto.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        avatarPhoto.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func createProfileName(){
        profileName = UILabel()
        profileName.textColor = UIColor(named: "WhiteText")
        profileName.font = .boldSystemFont(ofSize: 23)
        
        profileName.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(profileName)
        
        profileName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        profileName.topAnchor.constraint(equalTo: avatarPhoto.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createMailProfile() {
        mailProfile = UILabel()
        mailProfile.textColor = UIColor(named: "MailProfile")
        mailProfile.font = .systemFont(ofSize: 13)
        
        mailProfile.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mailProfile)
        
        mailProfile.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        mailProfile.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8).isActive = true
        mailProfile.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    private func createDescriptionProfile() {
        descriptionProfile = UILabel()
        descriptionProfile.textColor = UIColor(named: "WhiteText")
        descriptionProfile.font = .systemFont(ofSize: 13)
        
        descriptionProfile.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(descriptionProfile)
        
        descriptionProfile.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
        descriptionProfile.topAnchor.constraint(equalTo: mailProfile.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createExitButton() {
        guard let imageButton = UIImage(named: "Exit") else { return }
        exitButton = UIButton.systemButton(with: imageButton, target: self, action: #selector(Self.didTapExitButton))
        exitButton.tintColor = UIColor(named: "LikeButtonColor")
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(exitButton)
        
        exitButton.contentMode = .center
        exitButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: avatarPhoto.centerYAnchor).isActive = true
        
        exitButton.accessibilityIdentifier = "logoutButton"
    }
    
    @objc private func didTapExitButton() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        alert.view.accessibilityIdentifier = "ByeBye"
        
        let actionYes = UIAlertAction(
            title: "Да",
            style: .default
        ) { [weak self] _ in
            guard let self else { return }
            self.presenter?.logOut()
        }
        
        actionYes.accessibilityIdentifier = "Yes"
        
        let actionNo = UIAlertAction(
            title: "Нет",
            style: .default
        )
        
        alert.addAction(actionYes)
        alert.addAction(actionNo)
        
        self.present(alert, animated: true)
    }
}
