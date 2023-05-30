//
//  WidgetEventItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.01.2023.
//

import Foundation

/// Used by `Application` and `Widgets` targets
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
