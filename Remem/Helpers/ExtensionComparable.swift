//
//  ExtensionComparable.swift.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.01.2022.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
