//
//  MediumView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import SwiftUI
import WidgetKit

struct MediumView: View {
    var entry: SimpleEntry

    var body: some View {
        ZStack(alignment: .center, content: {
            Color(UIHelper.itemBackground).ignoresSafeArea()
            VStack {
                row(name: "smoking", amount: 2, goal: 2, bg: Color(UIHelper.goalReachedBackground))
                row(name: "coffee", amount: 0, goal: 5, bg: Color(UIHelper.goalNotReachedBackground))
                row(name: "regular item", amount: 1, goal: 2, bg: Color(UIHelper.background))
            }.padding()

        })
    }

    func row(name: String, amount: Int, goal: Int, bg: Color) -> some View {
        ZStack {
            bg.clipShape(Capsule())
            ZStack {
                Text(name)
                    .font(Font(uiFont: UIHelper.fontSmall))
                    .foregroundColor(Color(UIHelper.itemFont))
                HStack {
                    Spacer()
                    Text("\(amount)/\(goal)")
                        .font(Font(uiFont: UIHelper.fontSmall))
                        .foregroundColor(Color(UIHelper.itemFont))
                }.padding(.trailing)
            }
        }
    }
}

struct RememWidgets_Previews: PreviewProvider {
    static var previews: some View {
        MediumView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
