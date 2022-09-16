//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import IOSInterfaceAdapters
import WidgetKit

struct Provider: TimelineProvider {
    let listViewModel: EventsListViewModel

    init(listViewModel: EventsListViewModel) {
        self.listViewModel = listViewModel
    }

    //
    // TimelineProvider
    //

    typealias Entry = WidgetEventsListViewModel

    func placeholder(in context: Context) -> WidgetEventsListViewModel {
        WidgetEventsListViewModel(listViewModel: listViewModel)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEventsListViewModel) -> ()) {
        let entry = WidgetEventsListViewModel(listViewModel: listViewModel)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetEventsListViewModel] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WidgetEventsListViewModel(date: entryDate, listViewModel: listViewModel)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}
