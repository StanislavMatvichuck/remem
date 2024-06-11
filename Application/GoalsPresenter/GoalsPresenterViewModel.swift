//
//  GoalsPresenterViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import Domain
import Foundation

struct GoalsPresenterViewModel {
    private static let create = String(localizationId: localizationIdGoalsCreate)
    private static let manage = String(localizationId: localizationIdGoalsManage)

    let title: String

    init(goalsReader: GoalsReading, eventId: String) {
        self.title = goalsReader.hasGoals(eventId: eventId) ? Self.manage : Self.create
    }
}
