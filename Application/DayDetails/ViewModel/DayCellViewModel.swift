//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayCellViewModel {
    enum Animation { case new }

    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    let happening: Happening // passed to service
    let id: String

    let time: String
    var animation: Animation?

    init(
        id: String,
        happening: Happening,
        animation: Animation? = nil
    ) {
        self.id = id

        self.happening = happening
        self.time = Self.formatter.string(from: happening.dateCreated)
        self.animation = animation
    }

    func removeAnimation() -> DayCellViewModel { DayCellViewModel(id: id, happening: happening) }
}
