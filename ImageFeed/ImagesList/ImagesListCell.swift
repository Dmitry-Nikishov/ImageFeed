//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 17.02.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private var gradientLayer: CAGradientLayer?

    private func setupGradient() {
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 0).cgColor,
          UIColor(red: 0.102, green: 0.106, blue: 0.133, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.54, c: -0.54, d: 0, tx: 0.77, ty: 0))
        layer0.bounds = gradientView.bounds.insetBy(dx: -0.5*gradientView.bounds.size.width, dy: -0.5*gradientView.bounds.size.height)
        layer0.position = gradientView.center
        gradientView.layer.addSublayer(layer0)
        
        gradientLayer = layer0
    }
    
    func setupContent(image: UIImage, date: Date, isLiked: Bool) {
        cellImage.image = image
        dateLabel.text = dateFormatter.string(from: Date())

        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        setupGradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer?.removeFromSuperlayer()
    }
}
