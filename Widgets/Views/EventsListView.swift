//
//  EventsListView.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI
import WidgetsFramework

struct EventRow: Identifiable {
    let id = UUID()
    let viewModel: WidgetRowViewModeling
}

struct EventsListView: View {
    private let viewModel: WidgetViewModel

    init(_ viewModel: WidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        let eventsRows = eventsRows()

        ZStack(alignment: .center, content: {
            Color(UIHelper.itemBackground).ignoresSafeArea()
            VStack {
                ForEach(eventsRows) { row in
                    EventRowView(viewModel: row.viewModel)
                }
            }
            .padding(.vertical, 11)
            .padding(.horizontal)
        })
    }

    private func eventsRows() -> [EventRow] {
        var eventsRows = [EventRow]()

        for i in 0 ... 2 {
            guard let eventViewModel = viewModel.rowViewModel(at: i) else { continue }
            eventsRows.append(EventRow(viewModel: eventViewModel))
        }

        return eventsRows
    }
}
