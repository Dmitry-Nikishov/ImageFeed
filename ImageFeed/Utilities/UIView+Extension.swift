//
//  UIView+Extension.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 17.04.2023.
//

import UIKit

extension UIView {
    private func createGradientAnimation() -> CABasicAnimation {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        return gradientChangeAnimation
    }

    func createAnimatedGradient() {
        let gradient = CAGradientLayer()
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradient.frame = self.bounds
        gradient.cornerRadius = self.layer.cornerRadius
        gradient.masksToBounds = true
        
        let animation = createGradientAnimation()
        gradient.add(animation, forKey: "locationsChange")
        self.layer.insertSublayer(gradient, at: 0)
    }
        
    func deleteAnimatedGradient() {
        guard let layer = self.layer.sublayers?.compactMap({
            $0 as? CAGradientLayer
        }).first else {
            return
        }
        
        layer.removeFromSuperlayer()
    }
}
