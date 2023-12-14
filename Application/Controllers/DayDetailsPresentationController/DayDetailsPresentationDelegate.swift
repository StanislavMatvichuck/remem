//
//  DayDetailsPresentationDelegate.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.12.2023.
//

import Foundation

protocol DayDetailsPresentationControllerDelegate {
    func dismissCompleted()
}

extension WeekViewController: DayDetailsPresentationControllerDelegate {
    func dismissCompleted() {
        viewModel.timelineAnimatedCellIndex = nil
    }
}
