//
//  WeekControllerHelpers.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 28.11.2022.
//

@testable import Application
import XCTest

extension WeekController {
    var firstDay: WeekCell { day(at: IndexPath(row: 0, section: 0)) }

    func day(at index: IndexPath) -> WeekCell {
        do {
            let cell = viewRoot.collection.dataSource?.collectionView(
                viewRoot.collection,
                cellForItemAt: index
            )

            return try XCTUnwrap(cell as? WeekCell)
        } catch { fatalError("error getting day") }
    }
}
