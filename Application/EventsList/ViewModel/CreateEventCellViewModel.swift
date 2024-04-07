//
//  CreateEventCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Foundation

struct CreateEventCellViewModel {
    static let title = String(localizationId: "button.create")

    let isHighlighted: Bool

    init(eventsCount: Int) {
        self.isHighlighted = eventsCount == 0
    }
}
