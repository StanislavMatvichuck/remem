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
    let name: String
    let amount: String
}
