//
//  EventsListView.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI

struct EventsList: View {
    let items: [WidgetEventCellViewModel]

    init(items: [WidgetEventCellViewModel]) {
        if items.isEmpty {
            self.items = [.empty]
            return
        }

        var result = [WidgetEventCellViewModel]()

        items.prefix(3).forEach { result.append($0) }

        self.items = result
    }

    var body: some View {
        let spacing: CGFloat = 0

        if #available(iOSApplicationExtension 17.0, *) {
            ZStack(
                alignment: .center,
                content: {
                    VStack(spacing: spacing) {
                        ForEach(items, id: \.id) {
                            EventRow(item: $0)
                        }
                    }.padding(EdgeInsets(
                        top: spacing,
                        leading: 0,
                        bottom: spacing,
                        trailing: 0
                    ))
                }
            ).containerBackground(for: .widget, content: {
                Color(uiColor: UIColor.remem_bg)
            })
        } else {
            ZStack(
                alignment: .center,
                content: {
                    VStack(spacing: spacing) {
                        ForEach(items, id: \.id) {
                            EventRow(item: $0)
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
}
