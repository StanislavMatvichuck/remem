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
        try? removeFileFromDirectory()
        super.tearDown()
    }

    func testInit() {
        XCTAssertNotNil(sut)
    }

    func test_update_readerReadsUpdate() {
        // given
        let reader = WidgetFileReader()
        let mockViewModel = WidgetViewModel(
            viewModel: [
                WidgetRowViewModel(name: "Event name",
                                   amount: "0",
                                   hasGoal: false,
                                   goalReached: false),
            ]
        )

        // when
        sut.update(eventsList: [Event(name: "Event name")], for: .test)

        // then
        let fileDecodedViewModel = reader.read(for: .test)
        XCTAssertEqual(fileDecodedViewModel?.count, mockViewModel.count)
        XCTAssertEqual(fileDecodedViewModel?.rowViewModel(at: 0)?.name,
                       mockViewModel.rowViewModel(at: 0)?.name)
    }
}

extension WidgetFileWritingTests {
    private func removeFileFromDirectory() throws {
        guard let documentsDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.remem.io")
        else { return }

        let fileURL = documentsDir.appendingPathComponent("WidgetData.plist")

        try FileManager.default.removeItem(at: fileURL)
    }
}
