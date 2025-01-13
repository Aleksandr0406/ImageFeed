//
//  ViewController.swift
//  ImageFeed
//
//  Created by 1111 on 24.10.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    static var urlFull: URL?
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let service: ImagesListService = .shared
    private var photos: [Photo] = []
    private var dateFormatter = ISO8601DateFormatter()
    
    @IBOutlet private var tableView: UITableView!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
        } else {
            super.prepare(for: segue, sender: sender)
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
        
        if likedByUser == false {
            service.fetchIsLiked(tokenIn: token, idIn: id, requestTypeIn: "POST") { [weak self] (result: Result<IslikedPhotoStats, Error>) in
                guard self != nil else { return }
                
                switch result {
                case .success(let data):
                    print("ImagesListViewController: func imageListCellDidTapLike/ .success")
                    self?.photos[indexPath.row].likedByUser = !likedByUser
                    complition(.success(data))
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    print("Error pushing data in ImagesListService")
                }
            }
        } else {
            service.fetchIsLiked(tokenIn: token, idIn: id, requestTypeIn: "DELETE") { [weak self] (result: Result<IslikedPhotoStats, Error>) in
                guard self != nil else { return }
                
                switch result {
                case .success(let data):
                    self?.photos[indexPath.row].likedByUser = !likedByUser
                    complition(.success(data))
                case .failure:
                    print("Error pushing data in ImagesListService")
                }
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
        { _ in
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        guard let createdAt = photos[indexPath.row].createdAt,
        let date = dateFormatter.date(from: createdAt)
        else {
            print("ImagesListViewController: configCell")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "rus")
        dateFormatter.string(from: date)
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
}

//    MARK: оставил если необходимо будет поправить высоту фоток
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 400
//                guard let image = UIImage(named: photosName[indexPath.row]) else {
//                    print("ImagesListViewController: func tableView(...)")
//                    return 0
//                }
//
//                let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//                let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//                let imageWidth = image.size.width
//                let scale = imageViewWidth / imageWidth
//                let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
//                return cellHeight
//            }
//    }

