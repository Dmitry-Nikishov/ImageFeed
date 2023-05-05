//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    private var numberOfAvatarRequestUpdate = 0
    private var numberOfLogoutRequest = 0
    
    var logoutRequests: Int {
        numberOfLogoutRequest
    }
    
    var avatarUpdateRequests: Int {
        numberOfAvatarRequestUpdate
    }
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    
    func requestAvatarUpdate() {
        numberOfAvatarRequestUpdate += 1
    }
    
    func requestLogout() {
        numberOfLogoutRequest += 1
    }
}
