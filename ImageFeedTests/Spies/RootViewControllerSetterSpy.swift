//
//  RootViewControllerSetterSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import Foundation
import ImageFeed
import UIKit

final class RootViewControllerSetterSpy: RootViewControllerSetterProtocol {
    private var numOfSetterCalls = 0
    
    var calls: Int {
        numOfSetterCalls
    }
    
    func setRootViewController(
        for: UIWindow,
        controller: UIViewController
    ) {
        numOfSetterCalls += 1
    }
}
