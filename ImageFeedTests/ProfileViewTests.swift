//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 03.05.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testAvatarUpdateRequestAfterLoadShouldBeCalled() throws {
        let vc = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        vc.presenter = presenter
        
        _ = vc.view
        
        XCTAssertEqual(presenter.avatarUpdateRequests, 1)
    }
    
    func testPresenterSequenceWhileLogoutShouldBeCorrectInPositiveScenario() throws {
        let uiWindowProviderSpy = UIWindowProviderSpy(withNilUiWindow: false)
        let rootVcSetterSpy = RootViewControllerSetterSpy()
        let logoutCleanerSpy = LogoutCleanerSpy()
        
        let presenter = ProfileViewPresenter(
            uiWindowProvider: uiWindowProviderSpy,
            rootVcSetter: rootVcSetterSpy,
            logoutCleaner: logoutCleanerSpy
        )
        
        presenter.requestLogout()
        
        XCTAssertEqual(uiWindowProviderSpy.calls, 1)
        XCTAssertEqual(rootVcSetterSpy.calls, 1)
        XCTAssertEqual(logoutCleanerSpy.cleanUps, 1)
    }
    
    func testPresenterSequenceWhileLogoutShouldBeCorrectInFailureScenario() throws {
        let uiWindowProviderSpy = UIWindowProviderSpy(withNilUiWindow: true)
        let rootVcSetterSpy = RootViewControllerSetterSpy()
        let logoutCleanerSpy = LogoutCleanerSpy()
        
        let presenter = ProfileViewPresenter(
            uiWindowProvider: uiWindowProviderSpy,
            rootVcSetter: rootVcSetterSpy,
            logoutCleaner: logoutCleanerSpy
        )
        
        presenter.requestLogout()
        
        XCTAssertEqual(uiWindowProviderSpy.calls, 1)
        XCTAssertEqual(rootVcSetterSpy.calls, 0)
        XCTAssertEqual(logoutCleanerSpy.cleanUps, 0)
    }
}
