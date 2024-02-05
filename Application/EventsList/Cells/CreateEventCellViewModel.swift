//
//  CreateEventCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Foundation

struct CreateEventCellViewModel: Hashable {
    static let title = String(localizationId: "button.create")

    typealias TapHandler = () -> Void

    let isHighlighted: Bool
    private let tapHandler: TapHandler?

    init(eventsCount: Int, tapHandler: TapHandler? = nil) {
        self.isHighlighted = eventsCount == 0
        self.tapHandler = tapHandler
    }

    func handleTap() { tapHandler?() }

    static func == (lhs: CreateEventCellViewModel, rhs: CreateEventCellViewModel) -> Bool {
        lhs.isHighlighted == rhs.isHighlighted
    }

    func hash(into hasher: inout Hasher) { hasher.combine("CreateEventCellViewModel") }
}
