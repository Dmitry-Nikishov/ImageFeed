//
//  GradientViewBuilder.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 19.04.2023.
//

import UIKit

enum GradientViewTypes {
    case avatar
    case login
    case name
}

final class GradientViewBuilder {
    static func create(for type: GradientViewTypes) -> UIView {
        switch type {
        case .avatar:
            return UIView(
                frame: CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: 70,
                        height: 70
                    )
                )
            )
        case .login:
            return UIView(
                frame: CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: 235,
                        height: 28
                    )
                )
            )
        case .name:
            return UIView(
                frame: CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: 100,
                        height: 18
                    )
                )
            )
        }
    }
}
