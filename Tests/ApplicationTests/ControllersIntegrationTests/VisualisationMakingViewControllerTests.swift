//
//  VisualisationMakingViewControllerTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 03.12.2023.
//

@testable import Application
import XCTest

final class VisualisationMakingViewControllerTests: XCTestCase {
    func test_showsLocalisedTitle() {
        let sut = VisualisationMakingViewController(VisualisationMakingView())
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.viewRoot.button.titleLabel?.text, VisualisationMakingViewModel.title)
    }
}
