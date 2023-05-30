//
//  EventRowView.swift
//  RememWidgetsExtension
//
//  Created by Stanislav Matvichuck on 18.09.2022.
//

import SwiftUI

struct EventRow: View {
    let item: WidgetEventCellViewModel?

    @ViewBuilder
    var body: some View {
        if let item = item {
            ZStack {
                GeometryReader { geomery in
                    Color(
                        item.goalState == .achieved ?
                            UIColor.bg_goal_achieved :
                            UIColor.bg_goal
                    ).frame(width: geomery.size.width * item.progress)
                }

                HStack {
                    StyledText(item.title)

                    Spacer(minLength: 0)

                    ZStack {
                        Color(.clear).aspectRatio(1.0, contentMode: .fit)
                        StyledText(item.value)
                    }.aspectRatio(1.0, contentMode: .fit)
                }.padding(EdgeInsets(
                    top: 0,
                    leading: 15,
                    bottom: 0,
                    trailing: 0
                ))
            }.overlay(
                Divider().overlay(Color(uiColor: UIColor.bg_secondary)),
                alignment: .bottom
            ).overlay(
                TimeSinceText(item.timeSince),
                alignment: .bottom
            )
        } else {
            EventRowEmptyView()
        }
    }
}

struct EventRowEmptyView: View {
    var body: some View {
        Color(uiColor: UIColor.bg)
    }
}
