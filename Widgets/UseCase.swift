//
//  UseCase.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 10.12.2022.
//

import Domain
import WidgetKit

class WidgetsUseCase {
    private let repository: EventsRepositoryInterface

    init(repository: EventsRepositoryInterface) {
        self.repository = repository
    }

    func update() {
        WidgetFileWriter().update(
            today: DayComponents(date: .now),
            eventsList: repository.makeAllEvents(),
            for: .medium
        )

        WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
    }
}
