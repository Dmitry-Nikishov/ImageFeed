//
//  ViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 17.02.2023.
//

import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    func updateAnimated(with newPhotos: [Photo])
    func handleSuccessfullChangeLike(photos: [Photo], index: IndexPath)
    func handleFailureChangeLike(failureReason: Error)
}

final class ImagesListViewController: AppStyledViewController {
    private var photos: [Photo] = []
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBackground
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )
        view.register(
            ImagesListCell.self,
            forCellReuseIdentifier: String(describing: ImagesListCell.self)
        )
        
        return view
    }()
    
    var presenter: ImagesListViewPresenterProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        fetchPhotos()
        presenter?.registerNotificationObserver()
    }

    private func fetchPhotos() {
        UIBlockingProgressHUD.show()
        presenter?.fetchNextPagePhotos()
    }
        
    private func updateTableViewAnimated(with newPhotos: [Photo]) {
        let oldCount = photos.count
        let newCount = newPhotos.count
        photos = newPhotos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
        
    private func configCell(
        for cell: ImagesListCell,
        with indexPath: IndexPath
    ) {
        let photo = photos[indexPath.row]
        guard let imageURL = URL(string: photo.thumbImageURL) else {
            return
        }
        
        cell.backgroundColor = .black
        cell.selectionStyle = .none
        cell.cellState = .loading
                
        KingfisherManager.shared.retrieveImage(with: imageURL) {
            [weak self] result in
            switch result {
            case .success(let imageResult):
                cell.imageCell.kf.indicatorType = .none
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                cell.cellState = .finished(
                    imageResult.image,
                    PhotoHelpers.getCreatedDate(for: photo),
                    photo.isLiked
                )
            case .failure(let error):
                Logger.error("\(error)")
                cell.cellState = .error
            }
        }
    }

    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = .appBackground
        
        view.addSubview(tableView)

        let constraints = [
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let imageURL = photos[indexPath.row].largeImageURL
        
        let vc = SingleImageViewController(fullImageUrl: imageURL)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) == photos.count {
            fetchPhotos()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ImagesListCell.self),
            for: indexPath
        )

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        
        presenter?.requestChangeLike(
            photoId: photo.id,
            isLike: !photo.isLiked,
            index: indexPath
        )
    }
    
    private func showAlert(with error: Error) {
        let alert = UIAlertController(
            title: "Лайки сломались",
            message: "Ошибка - \(error)",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Oк", style: .cancel)
        alert.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

extension ImagesListViewController: ImagesListViewControllerProtocol {
    func updateAnimated(with newPhotos: [Photo]) {
        UIBlockingProgressHUD.dismiss()
        updateTableViewAnimated(with: newPhotos)
    }
    
    func handleSuccessfullChangeLike(photos: [Photo], index: IndexPath) {
        UIBlockingProgressHUD.dismiss()
        self.photos = photos
        tableView.reloadRows(at: [index], with: .automatic)
    }
    
    func handleFailureChangeLike(failureReason: Error) {
        UIBlockingProgressHUD.dismiss()
        showAlert(with: failureReason)
    }
}
