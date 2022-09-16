//
//  MediumView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import IOSInterfaceAdapters
import SwiftUI
import WidgetKit

struct EventsListView: View {
    var entry: WidgetEventsListViewModel

    var body: some View {
        ZStack(alignment: .center, content: {
            Color(UIHelper.itemBackground).ignoresSafeArea()
            VStack {
                row(forEventViewModel: entry.eventViewModel(atIndex: 0))
                row(forEventViewModel: entry.eventViewModel(atIndex: 1))
                row(forEventViewModel: entry.eventViewModel(atIndex: 2))
            }
            .padding(.vertical, 11)
            .padding(.horizontal)
        })
    }

    func row(name: String, amount: String, bg: Color) -> some View {
        ZStack {
            bg.clipShape(Capsule())
            ZStack {
                Text(name)
                    .font(Font(uiFont: UIHelper.fontSmall))
                    .foregroundColor(Color(UIHelper.itemFont))
                HStack {
                    Spacer()
                    Text(amount)
                        .font(Font(uiFont: UIHelper.fontSmall))
                        .foregroundColor(Color(UIHelper.itemFont))
                }.padding(.trailing)
            }
        }
    }

    func row(forEventViewModel: EventCellViewModelingState) -> some View {
        let defaultColor = Color(uiColor: UIHelper.background)
        let reachedColor = Color(uiColor: UIHelper.goalReachedBackground)
        let notReachedColor = Color(uiColor: UIHelper.goalNotReachedBackground)

        let backgroundColor: Color = {
            switch (forEventViewModel.hasGoal, forEventViewModel.goalReached) {
            case (true, true): return reachedColor
            case (true, false): return notReachedColor
            default: return defaultColor
            }
        }()

        return row(name: forEventViewModel.name,
                   amount: forEventViewModel.amount,
                   bg: backgroundColor)
    }
}
