//
//  EmptyView.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            Color(UIHelper.itemBackground).ignoresSafeArea()
            StyledText("Add event to track")
        })
    }
}
