//
//  RememWidgets.swift
//  RememWidgets
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import IOSInterfaceAdapters
import RememDomain
import SwiftUI
import WidgetKit

@main
struct RememWidgets: Widget, PreviewProvider {
    let kind: String = "RememWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            EventsListView(entry: entry)
        }
        .configurationDisplayName("Today goals")
        .description("A list of events with defined goals")
        .supportedFamilies([.systemMedium])
    }

    //
    //
    //

    let repository: EventsRepositoryMock
    let editUseCase: EventEditUseCase
    let listUseCase: EventsListUseCase
    let provider: Provider

    init() {
        let repository = EventsRepositoryMock()
        let editUseCase = EventEditUseCase(repository: repository)
        let listUseCase = EventsListUseCase(repository: repository)
        let listViewModel = EventsListViewModel(listUseCase: listUseCase, editUseCase: editUseCase)
        let provider = Provider(listViewModel: listViewModel)
        self.repository = repository
        self.editUseCase = editUseCase
        self.listUseCase = listUseCase
        self.provider = provider
    }

    //
    // PreviewProvider
    //

    static var previews: some View {
        let repository = EventsRepositoryMock()
        let listUseCase = EventsListUseCase(repository: repository)
        let editUseCase = EventEditUseCase(repository: repository)
        let listViewModel = EventsListViewModel(listUseCase: listUseCase, editUseCase: editUseCase)
        EventsListView(entry: WidgetEventsListViewModel(listViewModel: listViewModel))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct EventsRepositoryMock: EventsRepositoryInterface {
    func save(_: Event) {}
    func delete(_: Event) {}
    func save(_: [Event]) {}

    func all() -> [Event] { events }
    func event(byId _: String) -> Event? { nil }

    private let events: [Event] = {
        let event01 = Event(name: "🚬")
        let event02 = Event(name: "💊")
        event02.addGoal(at: .now, amount: 1)
        event02.addHappening(date: .now)
        let event03 = Event(name: "I have a Goal")
        event03.addGoal(at: .now, amount: 3)

        return [event01, event02, event03]
    }()
}
