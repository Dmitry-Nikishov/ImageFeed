//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 17.02.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    
    lazy var imageCell: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var loadingGradientView = UIView()
    private let gradientLayer = CAGradientLayer()
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cellState: FeedCellImageState? {
        didSet {
            switch cellState {
            case .loading:
                showAnimatedGradient()
            case .error:
                hideAnimatedGradient()
                imageCell.image = UIImage(named: "card_stub")
            case .finished(let image, let date, let isLiked):
                handleFinishedState(
                    withImage: image,
                    date: date,
                    isLiked: isLiked
                )
            default:
                break
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func handleFinishedState(
        withImage image: UIImage,
        date formattedDate: String,
        isLiked: Bool
    ) {
        hideAnimatedGradient()
        imageCell.image = image
        
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0).cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor
        ]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        dateLabel.text = formattedDate
        setIsLiked(isLike: isLiked)
    }

    private func setIsLiked(isLike: Bool) {
        likeButton.setImage(
            UIImage(named: isLike ? "like_button_on" : "like_button_off"),
            for: .normal
        )
    }

    private func showAnimatedGradient() {
        loadingGradientView.frame = bounds
        loadingGradientView.createAnimatedGradient()
        imageCell.addSubview(loadingGradientView)
    }
    
    private func hideAnimatedGradient() {
        loadingGradientView.deleteAnimatedGradient()
    }
    
    private func setupViews() {
        contentView.addSubview(imageCell)
        contentView.addSubview(gradientView)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)

        let constraints = [
            imageCell.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: imageCell.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),

            gradientView.heightAnchor.constraint(equalToConstant: 30),
            gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = gradientView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        hideAnimatedGradient()
        imageCell.kf.cancelDownloadTask()
    }

    func configure(
        image: UIImage,
        date: String,
        withLike: Bool
    ) {
        imageCell.image = image
        dateLabel.text = date
         
        likeButton.setImage(
            UIImage(named: withLike ? "like_button_on" : "like_button_off"),
            for: .normal
        )
    }

    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}
