//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Дмитрий Никишов on 05.05.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewTests: XCTestCase {
    func testCorrectPresenterCallsAtDidLoadStage() throws {
        let vc = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        presenter.view = vc
        vc.presenter = presenter
        
        _ = vc.view
        
        XCTAssertEqual(presenter.changeLikes, 0)
        XCTAssertEqual(presenter.newPhotosRequests, 1)
        XCTAssertEqual(presenter.observerRegistrations, 1)
    }

    func testPhotoDateMustBeFormedCorrectly() throws {
        let photo = Photo.getDummy(with: Date(timeIntervalSince1970: 0))
        let formattedString = PhotoHelpers.getCreatedDate(for: photo)
        
        XCTAssertEqual(formattedString, "1 января 1970 г.")
    }
}
