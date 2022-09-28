//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import WidgetKit
import WidgetsFramework

struct MediumWidgetTimelineEntry: TimelineEntry {
    var date: Date
    var vm: WidgetViewModel

    init(_ vm: WidgetViewModel) {
        self.date = .now
        self.vm = vm
    }
}

struct Provider: TimelineProvider {
    private let fileReader: WidgetFileReading

    init(repository: WidgetFileReading) { self.fileReader = repository }

    // TimelineProvider
    typealias Entry = MediumWidgetTimelineEntry

    func placeholder(in context: Context) -> MediumWidgetTimelineEntry {
        MediumWidgetTimelineEntry(fileReader.readStaticPreview())
    }

    func getSnapshot(in context: Context,
                     completion: @escaping (MediumWidgetTimelineEntry) -> ())
    {
        completion(MediumWidgetTimelineEntry(fileReader.readStaticPreview()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MediumWidgetTimelineEntry] = []

        if let viewModel = fileReader.read(for: .medium) {
            entries.append(MediumWidgetTimelineEntry(viewModel))
        }

        let timeline = Timeline(entries: entries, policy: .never)

        completion(timeline)
    }
}
