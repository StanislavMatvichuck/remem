//
//  WidgetFileReading.swift
//  Widgets
//
//  Created by Stanislav Matvichuck on 23.09.2022.
//

import Foundation

protocol WidgetFileReading {
    func read(url: URL) throws -> WidgetViewModel
}

class WidgetFileReader: WidgetFileReading {
    func read(url: URL) throws -> WidgetViewModel {
        WidgetViewModel(date: .now, viewModel: [])
    }
}
