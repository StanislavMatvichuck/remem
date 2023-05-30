//
//  EventsListView.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI

struct EventsList: View {
    let items: [WidgetEventCellViewModel?]

    init(items: [WidgetEventCellViewModel]) {
        if items.isEmpty {
            self.items = [WidgetEventCellViewModel(title: String(localizationId: "widget.emptyRow"), value: "!"), nil]
            return
        }

        var result = [WidgetEventCellViewModel?]()

        items.prefix(3).forEach { result.append($0) }

        while result.count < 3 { result.append(nil) }

        self.items = result
    }

    var body: some View {
        let spacing: CGFloat = 0

        ZStack(
            alignment: .center,
            content: {
                Color(uiColor: UIColor.bg).ignoresSafeArea()
                VStack(spacing: spacing) {
                    ForEach(items.indices) {
                        EventRow(isLast: $0 == 0, item: items[$0])
                    }
                }.padding(EdgeInsets(
                    top: spacing,
                    leading: 0,
                    bottom: spacing,
                    trailing: 0
                ))
            }
        )
    }
}
