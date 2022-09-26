//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import WidgetKit
import WidgetsFramework

struct Provider: TimelineProvider {
    private let repository: WidgetFileReading

    init(repository: WidgetFileReading) {
        self.repository = repository
    }

    //
    // TimelineProvider
    //

    typealias Entry = WidgetViewModel

    func placeholder(in context: Context) -> WidgetViewModel {
        repository.readStaticPreview()
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetViewModel) -> ()) {
        completion(repository.readStaticPreview())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetViewModel] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = repository.readStaticPreview()
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
