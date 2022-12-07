//
//  ClockSectionDescription.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockItemViewModel {
    let index: Int
    let length: CGFloat
    var isEmpty: Bool { length == 0 }
}
