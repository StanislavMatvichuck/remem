//
//  WidgetUseCase.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import Domain
import IosUseCases
import WidgetKit
import WidgetsFramework

public class WidgetsUseCase: WidgetsUseCasing {
    private let repository: EventsRepositoryInterface

    public init(repository: EventsRepositoryInterface) {
        self.repository = repository
    }

    public func update() {
        let events = repository.makeAllEvents()
        let writer = WidgetFileWriter()
        writer.update(eventsList: events, for: .medium)
        WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
    }
}
