//
//  WidgetEventItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.01.2023.
//

import Foundation

/// File used by `Application` and `Widgets` targets
struct WidgetEventCellViewModel: Codable, Identifiable {
    let id: UUID
    let title: String
    let value: String
    let timeSince: String
    let progress: CGFloat?
    var achieved: Bool { progress != nil && progress! >= 1 }
}

extension WidgetEventCellViewModel {
    static let empty = WidgetEventCellViewModel(
        id: UUID(),
        title: String(localizationId: localizationIdWidgetEmpty),
        value: "!",
        timeSince: localizationIdEventsListEventCellTimeSince,
        progress: nil
    )
}
