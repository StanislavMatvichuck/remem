//
//  WidgetFileWritingTests.swift
//  WidgetsFrameworkTests
//
//  Created by Stanislav Matvichuck on 22.09.2022.
//

import Domain
import WidgetsFramework
import XCTest

class WidgetFileWritingTests: XCTestCase {
    private var sut: WidgetFileWriting!

    override func setUp() {
        super.setUp()
        sut = WidgetFileWriter()
    }

    override func tearDown() {
        sut = nil
        clearDocumentsDirectory()
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_update_readerReadsUpdate() {
        // given
        let reader = WidgetFileReader()
        let mockViewModel = WidgetViewModel(
            date: .now,
            viewModel: [
                WidgetRowViewModel(name: "Event name",
                                   amount: "0",
                                   hasGoal: false,
                                   goalReached: false),
            ]
        )

        // when
        sut.update(eventsList: [Event(name: "Event name")])

        // then
        let fileDecodedViewModel = reader.read()
        XCTAssertEqual(fileDecodedViewModel?.count, mockViewModel.count)
        XCTAssertEqual(fileDecodedViewModel?.rowViewModel(at: 0)?.name,
                       mockViewModel.rowViewModel(at: 0)?.name)
    }
}

extension WidgetFileWritingTests {
    private func clearDocumentsDirectory() {
        let documentsDir = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        guard
            let documentsDirContent = try? FileManager.default.contentsOfDirectory(
                at: documentsDir,
                includingPropertiesForKeys: nil
            )
        else { return }

        for file in documentsDirContent {
            try? FileManager.default.removeItem(at: file)
        }
    }
}
