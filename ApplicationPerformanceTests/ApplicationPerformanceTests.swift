//
//  ApplicationPerformanceTests.swift
//  ApplicationPerformanceTests
//
//  Created by Stanislav Matvichuck on 30.01.2023.
//

import XCTest

final class ApplicationPerformanceTests: XCTestCase {
    func test_applicationLaunch() {
        measure() {
            print("done")
        }
    }
}
