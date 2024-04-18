//
//  RemovalDropAreaViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.04.2024.
//

import Foundation

struct RemovalDropAreaViewModel {
    var removalDropAreaHidden = true
    var removalDropAreaActive = false
    var draggedCellIndex: Int?

    mutating func startDragFor(eventIndex: Int) {
        draggedCellIndex = eventIndex
        removalDropAreaHidden = false
    }

    mutating func endDrag() { removalDropAreaHidden = true }
    mutating func activateDropArea() { removalDropAreaActive = true }
    mutating func deactivateDropArea() { removalDropAreaActive = false }
}
