//
//  UIWindowProviderSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import Foundation
import ImageFeed
import UIKit

final class UIWindowProviderSpy: UIWindowProviderProtocol {
    private var numOfGetterCalls = 0
    private let withNilUiWindow: Bool
    
    
    var calls: Int {
        numOfGetterCalls
    }
    
    init(withNilUiWindow: Bool) {
        self.withNilUiWindow = withNilUiWindow
    }

    func getFirstWindow() -> UIWindow? {
        numOfGetterCalls += 1
        return withNilUiWindow ? nil : UIWindow()
    }
}
