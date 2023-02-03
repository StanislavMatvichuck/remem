//
//  EventsListView.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI

struct EventsList: View {
    let items: [WidgetEventItemViewModel?]
    init(items: [WidgetEventItemViewModel]) {
        var threeItems: [WidgetEventItemViewModel?] = [nil, nil, nil]
        threeItems.replaceSubrange(0 ..< items.count, with: items)
        self.items = threeItems
    }

    var body: some View {
        let spacing: CGFloat = 0

        ZStack(
            alignment: .center,
            content: {
                Color(UIHelper.itemBackground).ignoresSafeArea()
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
