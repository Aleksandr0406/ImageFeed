//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by 1111 on 31.10.2024.
//

import Foundation
import UIKit

final class ProfileViewController: UIViewController {
    private var avatarPhoto: UIImageView = UIImageView()
    private var profileName: UILabel = UILabel()
    private var mailProfile: UILabel = UILabel()
    private var descriptionProfile: UILabel = UILabel()
    private var exitButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileImage()
        createProfileName()
        createMailProfile()
        createDescriptionProfile()
        createExitButton()
    }
    
    @objc private func didTapExitButton() {
        // TODO: добавить потом логику
    }
    
    private func createProfileImage() {
        let profileImage = UIImage(named: "AlternativeAvatarPhoto")
        avatarPhoto = UIImageView(image: profileImage)
        
        avatarPhoto.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarPhoto)
        
        avatarPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        avatarPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func createProfileName(){
        profileName = UILabel()
        profileName.text = "Лея"
        profileName.textColor = UIColor(named: "WhiteText")
        profileName.font = .boldSystemFont(ofSize: 23)
        
        profileName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileName)
        
        profileName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileName.topAnchor.constraint(equalTo: avatarPhoto.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createMailProfile() {
        mailProfile = UILabel()
        mailProfile.text = "@catlea"
        mailProfile.textColor = UIColor(named: "MailProfile")
        mailProfile.font = .systemFont(ofSize: 13)
        
        mailProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailProfile)
        
        mailProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        mailProfile.topAnchor.constraint(equalTo: profileName.bottomAnchor, constant: 8).isActive = true
        mailProfile.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    private func createDescriptionProfile() {
        descriptionProfile = UILabel()
        descriptionProfile.text = "Meow, world!"
        descriptionProfile.textColor = UIColor(named: "WhiteText")
        descriptionProfile.font = .systemFont(ofSize: 13)
        
        descriptionProfile.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionProfile)
        
        descriptionProfile.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        descriptionProfile.topAnchor.constraint(equalTo: mailProfile.bottomAnchor, constant: 8).isActive = true
    }
    
    private func createExitButton() {
        let imageButton = UIImage(named: "Exit")
        exitButton = UIButton.systemButton(with: imageButton!, target: self, action: #selector(Self.didTapExitButton))
        exitButton.tintColor = UIColor(named: "LikeButtonColor")
        
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        exitButton.contentMode = .center
        exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        exitButton.centerYAnchor.constraint(equalTo: avatarPhoto.centerYAnchor).isActive = true
    }
}
