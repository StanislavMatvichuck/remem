//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import WidgetKit

struct MediumWidgetTimelineEntry: TimelineEntry {
    var date: Date
    var items: [WidgetEventItemViewModel]

    init(items: [WidgetEventItemViewModel]) {
        self.date = .now
        self.items = items
    }
}

struct Provider: TimelineProvider {
    typealias Entry = MediumWidgetTimelineEntry

    let provider: WidgetEventsQuerying
    init(provider: WidgetEventsQuerying) {
        self.provider = provider
    }

    func placeholder(in context: Context) -> MediumWidgetTimelineEntry {
        MediumWidgetTimelineEntry(items: provider.getPreview())
    }

    func getSnapshot(in context: Context, completion: @escaping (MediumWidgetTimelineEntry) -> ()) {
        completion(MediumWidgetTimelineEntry(items: provider.getPreview()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let timeline = Timeline(
            entries: [MediumWidgetTimelineEntry(items: provider.getFromFile())],
            policy: .never
        )

        completion(timeline)
    }
}
