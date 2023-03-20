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
        if items.isEmpty {
            self.items = [WidgetEventItemViewModel(name: String(localizationId: "widget.emptyRow"), amount: "!"), nil]
            return
        }

        var result = [WidgetEventItemViewModel?]()

        items.prefix(3).forEach { result.append($0) }

        while result.count < 3 { result.append(nil) }

        self.items = result
    }

    var body: some View {
        let spacing: CGFloat = 0

        ZStack(
            alignment: .center,
            content: {
                Color(uiColor: UIColor.background).ignoresSafeArea()
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
