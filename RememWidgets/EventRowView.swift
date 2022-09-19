//
//  EventRowView.swift
//  RememWidgetsExtension
//
//  Created by Stanislav Matvichuck on 18.09.2022.
//

import SwiftUI

struct EventRowView: View {
    let row: EventRow

    var body: some View {
        let defaultColor = Color(uiColor: UIHelper.background)
        let reachedColor = Color(uiColor: UIHelper.goalReachedBackground)
        let notReachedColor = Color(uiColor: UIHelper.goalNotReachedBackground)

        let backgroundColor: Color = {
            switch (row.viewModel.hasGoal, row.viewModel.goalReached) {
            case (true, true): return reachedColor
            case (true, false): return notReachedColor
            default: return defaultColor
            }
        }()

        ZStack {
            backgroundColor.clipShape(Capsule())
            ZStack {
                Text(row.viewModel.name)
                    .font(Font(uiFont: UIHelper.fontSmall))
                    .foregroundColor(Color(UIHelper.itemFont))
                HStack {
                    Spacer()
                    Text(row.viewModel.amount)
                        .font(Font(uiFont: UIHelper.fontSmall))
                        .foregroundColor(Color(UIHelper.itemFont))
                }.padding(.trailing)
            }
        }
    }
}
