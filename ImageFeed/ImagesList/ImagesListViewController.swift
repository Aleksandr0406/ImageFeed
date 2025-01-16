//
//  ViewController.swift
//  ImageFeed
//
//  Created by 1111 on 24.10.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    static var urlFull: URL?
    
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let service: ImagesListService = .shared
    private var photos: [Photo] = []
    private var dateFormatterISO = ISO8601DateFormatter()
    private var dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        service.fetchPhotosNextPage { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPhoto):
                photos += newPhoto
                service.photos += newPhoto
                tableView.reloadData()
            case .failure:
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == photos.count - 1 else { return }
        service.fetchPhotosNextPage() { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let newPhoto):
                photos += newPhoto
                service.photos += newPhoto
                print(photos.count)
                tableView.reloadData()
            case .failure:
                print("ImagesListViewController: func fetchPhotosNextPage ")
            }
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("ImagesListViewController: func tableView(...) Не смогли привести к необходимому типу")
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        setupGradientView(imageListCell)
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}


extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell, complition: @escaping (Result<IslikedPhotoStats, Error>) -> Void) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        
        guard let id = photo.id,
              let likedByUser = photo.likedByUser,
              let token = OAuth2TokenStorage.shared.token else {
            print("ImagesListViewController: func imageListCellDidTapLike/ guard let id")
            return
        }
        
        service.setLikeState(likedByUser, token, id) { [weak self] (result: Result<IslikedPhotoStats, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                print("ImagesListViewController: func imageListCellDidTapLike/ .success")
                self.photos[indexPath.row].likedByUser = !likedByUser
                complition(.success(data))
            case .failure:
                UIBlockingProgressHUD.dismiss()
                print("ImagesListViewController: func imageListCellDidTapLike/ .failure")
            }
        }
    }
}

private extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: photos[indexPath.row].urls?.regular,
                                   placeholder: UIImage(named: "PlaceholderForImage"),
                                   options: [.transition(.fade(1))]
        )
        { [weak self] _ in
            guard let self else {
                print("extension ImagesListViewController: configCell guard")
                return
            }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        guard let createdAt = photos[indexPath.row].createdAt,
              let date = dateFormatterISO.date(from: createdAt)
        else {
            print("ImagesListViewController: configCell")
            return
        }
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "rus")
        cell.dateLabel.text = dateFormatter.string(from: date)
        
        guard let isLiked = photos[indexPath.row].likedByUser else {
            print("ImagesListViewController: func configCell/guard isLiked ")
            return
        }
        let likeImage = isLiked ? UIImage(named: "Like_button_on") : UIImage(named: "Like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func setupGradientView(_ cell: ImagesListCell) {
        let gradient = CAGradientLayer()
        guard let colorTop: UIColor = UIColor(named: "BlackGradientTop"),
              let colorBottom: UIColor = UIColor(named: "BlackGradientBottom") else {
            print("ImagesListViewController: func setupGradientView(...)")
            return
        }
        
        gradient.colors = [colorTop, colorBottom]
        gradient.frame = cell.gradientView.bounds
        cell.gradientView.layer.addSublayer(gradient)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ImagesListViewController.urlFull = photos[indexPath.row].urls?.full
        print("URLFULL", ImagesListViewController.urlFull!)
        
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        guard let imageWidth = photos[indexPath.row].width,
              let imageHeight = photos[indexPath.row].height else {
            print("ImagesListViewController: tableView/ height cell")
            return CGFloat() }
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageHeight * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

