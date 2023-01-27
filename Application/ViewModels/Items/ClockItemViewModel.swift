//
//  ClockSectionDescription.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockItemViewModel: Equatable {
    let index: Int
    let length: CGFloat
    let clockSize: Int
    var isEmpty: Bool { length == 0 }
}
