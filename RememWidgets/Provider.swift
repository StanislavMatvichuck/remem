//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import WidgetKit

struct Provider: TimelineProvider {
    public typealias Entry = MediumEntry

    func placeholder(in context: Context) -> MediumEntry {
        MediumEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (MediumEntry) -> ()) {
        let entry = MediumEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MediumEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MediumEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
