//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import WidgetsFramework
import WidgetKit

struct Provider: TimelineProvider {
    private let repository: WidgetFileReading
    private let viewModel: WidgetViewModel

    init(repository: WidgetFileReading) {
        self.repository = repository
        self.viewModel = WidgetViewModel(date: .now, viewModel: [])
    }

    //
    // TimelineProvider
    //

    typealias Entry = WidgetViewModel

    func placeholder(in context: Context) -> WidgetViewModel {
        viewModel
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetViewModel) -> ()) {
        completion(viewModel)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetViewModel] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WidgetViewModel(date: entryDate, viewModel: [])
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
