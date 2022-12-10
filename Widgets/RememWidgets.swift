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
        let repository = WidgetFileReader()
        self.provider = Provider(repository: repository)
    }

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            MediumWidgetView(viewModel: entry.vm)
        }
        .configurationDisplayName("Today goals")
        .description("A list of events with defined goals")
        .supportedFamilies([.systemMedium])
    }

    // PreviewProvider
    static var previews: some View {
        let reader = WidgetFileReader()
        MediumWidgetView(viewModel: reader.readStaticPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
