//
//  CreateEventCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import Foundation

struct CreateEventCellViewModel: Hashable {
    typealias TapHandler = () -> Void
    static let title = String(localizationId: "button.create")

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

    func hash(into hasher: inout Hasher) { hasher.combine("Footer") }
}
