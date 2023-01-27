//
//  RememWidgets.swift
//  RememWidgets
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import SwiftUI
import WidgetKit

@main
struct RememWidgets: Widget, PreviewProvider {
    let kind: String = "RememWidgets"
    let provider: Provider

    init() {
        self.provider = Provider(provider: WidgetEventsQuerying())
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            EventsList(items: entry.items)
        }
        .configurationDisplayName("Today goals")
        .description("A list of events with defined goals")
        .supportedFamilies([.systemMedium])
    }

    // PreviewProvider
    static var previews: some View {
        let provider = Provider(provider: WidgetEventsQuerying())
        EventsList(items: provider.provider.getPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
