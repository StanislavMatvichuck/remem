//
//  StyledText.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 27.09.2022.
//

import SwiftUI

struct StyledText: View {
    private let content: String

    init(_ content: String) {
        self.content = content
    }

    var body: some View {
        Text(content)
            .font(Font(uiFont: .font))
            .foregroundColor(Color(UIColor.text))
    }
}
