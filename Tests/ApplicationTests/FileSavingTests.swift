//
//  FileSavingTests.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

@testable import Application
import XCTest
import DataLayer

final class FileSavingTests: XCTestCase {
    func test_save_createsFile() throws {
        let url = LocalFile.testingPdfReport.url
        let sut = DefaultLocalFileSaver()

        sut.save(Data(), to: url)

        XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))

        try FileManager.default.removeItem(atPath: url.path)
    }
}
