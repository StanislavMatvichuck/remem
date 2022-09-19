//
//  MediumView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import IOSInterfaceAdapters
import SwiftUI
import WidgetKit

struct EventRow: Identifiable {
    let id = UUID()
    let viewModel: EventCellViewModelingState
}

struct EventsListView: View {
    var viewModel: WidgetViewModel

    var body: some View {
        if viewModel.listViewModel.hint == .empty {
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
                    EventRowView(row: row)
                }
            }
            .padding(.vertical, 11)
            .padding(.horizontal)
        })
    }

    private func eventsRows() -> [EventRow] {
        var eventsRows = [EventRow]()

        for i in 0 ... 2 {
            guard let eventViewModel = viewModel.eventViewModel(atIndex: i) else { continue }
            eventsRows.append(EventRow(viewModel: eventViewModel))
        }

        return eventsRows
    }
}
