//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
