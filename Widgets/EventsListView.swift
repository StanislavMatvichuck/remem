//
//  MediumView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import SwiftUI
import WidgetKit

struct EventRow: Identifiable {
    let id = UUID()
    let viewModel: WidgetRowViewModeling
}

struct EventsListView: View {
    var viewModel: WidgetViewModel

    var body: some View {
        if viewModel.count == 0 {
            ZStack(alignment: .center, content: {
                Color(UIHelper.itemBackground).ignoresSafeArea()
                Text("Add event to track")
                    .padding()
            })
        }

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
