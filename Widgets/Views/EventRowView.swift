//
//  EventRowView.swift
//  RememWidgetsExtension
//
//  Created by Stanislav Matvichuck on 18.09.2022.
//

import SwiftUI
import WidgetsFramework

struct EventRowView: View {
    let viewModel: WidgetRowViewModeling?

    @ViewBuilder
    var body: some View {
        if let viewModel = viewModel {
            let defaultColor = Color(uiColor: UIHelper.background)
            let reachedColor = Color(uiColor: UIHelper.goalReachedBackground)
            let notReachedColor = Color(uiColor: UIHelper.goalNotReachedBackground)

            let backgroundColor: Color = {
                switch (viewModel.hasGoal, viewModel.goalReached) {
                case (true, true): return reachedColor
                case (true, false): return notReachedColor
                default: return defaultColor
                }
            }()

            ZStack {
                backgroundColor.clipShape(Capsule())
                HStack {
                    Color(.clear)
                        .aspectRatio(1.0, contentMode: .fit)
                    Spacer(minLength: 0)
                    Text(viewModel.name)
                        .font(Font(uiFont: UIHelper.fontSmall))
                        .foregroundColor(Color(UIHelper.itemFont))
                    Spacer(minLength: 0)
                    ZStack {
                        Color(.clear)
                            .aspectRatio(1.0, contentMode: .fit)
                        Text(viewModel.amount)
                            .font(Font(uiFont: UIHelper.fontSmall))
                            .foregroundColor(Color(UIHelper.itemFont))
                    }.aspectRatio(1.0, contentMode: .fit)
                }
            }
        } else {
            EventRowEmptyView()
        }
    }
}

struct EventRowEmptyView: View {
    var body: some View {
        Color(uiColor: UIHelper.itemBackground)
    }
}
