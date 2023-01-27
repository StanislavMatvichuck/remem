//
//  EventsListView.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI

struct EventsList: View {
    let items: [WidgetEventItemViewModel]
    init(items: [WidgetEventItemViewModel]) {
        self.items = items
    }

    var body: some View {
        let spacing: CGFloat = 0

        ZStack(
            alignment: .center,
            content: {
                Color(UIHelper.itemBackground).ignoresSafeArea()
                VStack(spacing: spacing) {
                    ForEach(items.indices.prefix(3)) {
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
