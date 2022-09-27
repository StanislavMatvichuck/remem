//
//  MediumView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import SwiftUI
import WidgetKit
import WidgetsFramework

struct MediumWidgetView: View {
    var viewModel: WidgetViewModel

    @ViewBuilder
    var body: some View {
        if viewModel.count == 0 {
            EmptyView()
        } else {
            EventsListView(viewModel)
        }
    }
}
