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
    let viewModel: WidgetRowViewModeling?
}

struct EventsListView: View {
    private let viewModel: WidgetViewModel

    init(_ viewModel: WidgetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        let spacing: CGFloat = 5
        let eventsRows = eventsRows()

        ZStack(alignment: .center, content: {
            Color(UIHelper.itemBackground).ignoresSafeArea()
            VStack(spacing: spacing) {
                ForEach(eventsRows) { row in
                    EventRowView(viewModel: row.viewModel)
                }
            }.padding(EdgeInsets(top: spacing, leading: 5 * spacing, bottom: spacing, trailing: 5 * spacing))
        })
    }

    private func eventsRows() -> [EventRow] {
        var eventsRows = [EventRow]()

        for i in 0 ... 2 {
            guard let eventViewModel = viewModel.rowViewModel(at: i) else {
                eventsRows.append(EventRow(viewModel: nil))
                continue
            }

            eventsRows.append(EventRow(viewModel: eventViewModel))
        }

        return eventsRows
    }
}
