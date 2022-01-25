//
//  ExtensionEntry.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import Foundation

extension Entry {
    var totalAmount: Int {
        guard let points = self.points else { return 0 }

        return points.reduce(0) { partialResult, point in
            if let point = point as? Point {
                return partialResult + Int(point.value)
            } else {
                return partialResult
            }
        }
    }
}
