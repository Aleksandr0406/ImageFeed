//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by 1111 on 25.10.2024.
//

import Foundation
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell, complition: @escaping (Result<IslikedPhotoStats, Error>) -> Void)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var gradientView: UIImageView!
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    private let service: ImagesListService = .shared
    
    override func prepareForReuse() {
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func pressLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self) { [weak self] result in
            guard let self else {
                print("ImagesListCell: func likeButton")
                return
            }
            switch result {
            case .success(let data):
                guard let isLiked = data.photo?.likedByUser else {
                    print("ImagesListCell: func likeButton")
                    return
                }
                let likeImage = isLiked ? UIImage(named: "Like_button_on") : UIImage(named: "Like_button_off")
                DispatchQueue.main.async {
                    self.likeButton.setImage(likeImage, for: .normal)
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure:
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
}
