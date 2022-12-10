//
//  EventsListView.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI

struct EventRow: Identifiable {
    let id = UUID()
    let viewModel: WidgetRowViewModel
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
        viewModel.items.map { EventRow(viewModel: $0) }
    }
}
