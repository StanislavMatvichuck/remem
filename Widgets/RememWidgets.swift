//
//  RememWidgets.swift
//  RememWidgets
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import SwiftUI
import WidgetKit
import WidgetsFramework

@main
struct RememWidgets: Widget, PreviewProvider {
    let kind: String = "RememWidgets"
    let provider: Provider

    init() {
        let repository = WidgetFileReader()
        self.provider = Provider(repository: repository)
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            EventsListView(viewModel: entry)
        }
        .configurationDisplayName("Today goals")
        .description("A list of events with defined goals")
        .supportedFamilies([.systemMedium])
    }

    // PreviewProvider
    static var previews: some View {
        let reader = WidgetFileReader()
        EventsListView(viewModel: reader.readStaticPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
