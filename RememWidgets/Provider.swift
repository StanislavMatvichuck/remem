//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import IOSInterfaceAdapters
import WidgetKit

struct Provider: TimelineProvider {
    private let repository: WidgetRepositoryInterface
    private let listViewModel: EventsListViewModelState

    init(repository: WidgetRepositoryInterface) {
        self.repository = repository
        self.listViewModel = WidgetEventsListViewModel(events: [])
    }

    //
    // TimelineProvider
    //

    typealias Entry = WidgetViewModel

    func placeholder(in context: Context) -> WidgetViewModel {
        WidgetViewModel(listViewModel: listViewModel)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetViewModel) -> ()) {
        let entry = WidgetViewModel(listViewModel: listViewModel)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetViewModel] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WidgetViewModel(date: entryDate, listViewModel: listViewModel)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
