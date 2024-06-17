//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayCellViewModel: Identifiable {
    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    let happening: Happening // passed to service
    let id: UUID

    let time: String

    init(id: UUID, happening: Happening) {
        self.id = id
        self.happening = happening
        self.time = Self.formatter.string(from: happening.dateCreated)
    }

    func removeAnimation() -> DayCellViewModel { DayCellViewModel(id: id, happening: happening) }
}
