//
//  LogoutCleanerSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import Foundation
import ImageFeed

final class LogoutCleanerSpy: LogoutCleanerProtocol {
    private var numberOfCleanUps = 0
    
    var cleanUps: Int {
        numberOfCleanUps
    }
    
    func performCleanUp() {
        numberOfCleanUps += 1
    }
}
