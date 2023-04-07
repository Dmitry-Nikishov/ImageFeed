//
//  ViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 17.02.2023.
//

import UIKit

final class ImagesListViewController: AppStyledViewController {
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
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
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func configCell(
        for cell: ImagesListCell,
        with indexPath: IndexPath
    ) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return
        }
    
        cell.selectionStyle = .none
        cell.backgroundColor = .appBackground
        cell.configure(
            image: image,
            date: dateFormatter.string(from: Date()),
            withLike: indexPath.row % 2 == 0
        )
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
        let vc = SingleImageViewController(
            image: UIImage(named: photosName[indexPath.row]) ?? UIImage()
        )
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ImagesListCell.self),
            for: indexPath
        )

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
