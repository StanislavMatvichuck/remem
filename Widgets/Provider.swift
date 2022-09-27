//
//  Provider.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import WidgetKit
import WidgetsFramework

struct Provider: TimelineProvider {
    private let fileReader: WidgetFileReading

    init(repository: WidgetFileReading) { self.fileReader = repository }

    // TimelineProvider
    typealias Entry = WidgetViewModel

    func placeholder(in context: Context) -> WidgetViewModel {
        fileReader.readStaticPreview()
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetViewModel) -> ()) {
        completion(fileReader.readStaticPreview())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetViewModel] = []

        if let entry = fileReader.read(for: .medium) { entries.append(entry) }

        let timeline = Timeline(entries: entries, policy: .never)

        completion(timeline)
    }
}
