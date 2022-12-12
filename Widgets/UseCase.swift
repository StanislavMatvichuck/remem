//
//  UseCase.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 10.12.2022.
//

import Domain
import WidgetKit

class WidgetsUseCase {
    private let provider: EventsQuerying

    init(provider: EventsQuerying) {
        self.provider = provider
    }

    func update() {
        WidgetFileWriter().update(
            today: DayComponents(date: .now),
            eventsList: provider.get(),
            for: .medium
        )

        WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
    }
}
