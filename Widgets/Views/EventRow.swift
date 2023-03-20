//
//  EventRowView.swift
//  RememWidgetsExtension
//
//  Created by Stanislav Matvichuck on 18.09.2022.
//

import SwiftUI

struct EventRow: View {
    let isLast: Bool
    let item: WidgetEventItemViewModel?

    @ViewBuilder
    var body: some View {
        if let item = item {
            ZStack {
                HStack {
                    StyledText(item.name)

                    Spacer(minLength: 0)
                    ZStack {
                        Color(.clear).aspectRatio(1.0, contentMode: .fit)
                        StyledText(item.amount)
                    }.aspectRatio(1.0, contentMode: .fit)
                }.padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
            }.overlay(
                Divider().background(Color(uiColor: UIColor.secondary)),
                alignment: .bottom
            )
        } else {
            EventRowEmptyView()
        }
    }
}

struct EventRowEmptyView: View {
    var body: some View {
        Color(uiColor: UIColor.background)
    }
}
