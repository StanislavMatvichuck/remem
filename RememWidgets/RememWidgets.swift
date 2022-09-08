//
//  RememWidgets.swift
//  RememWidgets
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import SwiftUI
import WidgetKit

@main
struct RememWidgets: Widget {
    let kind: String = "RememWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MediumView(entry: entry)
        }
        .configurationDisplayName("Today goals")
        .description("A list of events with defined goals")
        .supportedFamilies([.systemMedium])
    }
}
