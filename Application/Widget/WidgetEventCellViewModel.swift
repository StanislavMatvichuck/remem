//
//  WidgetEventItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.01.2023.
//

import Foundation

/// File used by `Application` and `Widgets` targets

enum GoalState: Int, Codable {
    case notAchieved, achieved
}

struct WidgetEventCellViewModel: Codable, Identifiable {
    var id = UUID()
    let title: String
    let value: String
    let timeSince: String
}

extension WidgetEventCellViewModel {
    static let empty = WidgetEventCellViewModel(
        title: String(localizationId: "widget.emptyRow"),
        value: "!",
        timeSince: "time since"
    )
}
