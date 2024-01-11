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
        return StaticConfiguration(kind: kind, provider: provider) { entry in
            EventsList(items: entry.items)
        }
        .configurationDisplayName(String(localizationId: "widget.title"))
        .description(String(localizationId: "widget.subtitle"))
        .supportedFamilies([.systemMedium])
        .containerBackgroundRemovable(false)
        .contentMarginsDisabled()
    }

    // PreviewProvider
    static var previews: some View {
        let provider = Provider(provider: WidgetEventsQuerying())
        return EventsList(items: provider.provider.getPreview())
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
