//
//  RememWidgets.swift
//  RememWidgets
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import IOSInterfaceAdapters
import RememDataLayer
import RememDomain
import SwiftUI
import WidgetKit

@main
struct RememWidgets: Widget, PreviewProvider {
    let kind: String = "RememWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: provider) { entry in
            EventsListView(viewModel: entry)
        }
        .configurationDisplayName("Today goals")
        .description("A list of events with defined goals")
        .supportedFamilies([.systemMedium])
    }

    //
    //
    //

    let provider: Provider

    init() {
        let repository = FileWidgetRepository()
        self.provider = Provider(repository: repository)
    }

    //
    // PreviewProvider
    //

    static var previews: some View {
        let listViewModel = WidgetEventsListViewModel(events: [])
        let widgetViewModel = WidgetViewModel(listViewModel: listViewModel)
        EventsListView(viewModel: widgetViewModel)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
