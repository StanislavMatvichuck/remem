//
//  Helpers.swift
//  RememWidgetsExtension
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import SwiftUI

public extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
}
