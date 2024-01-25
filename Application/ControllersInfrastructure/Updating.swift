//
//  Updating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 11.03.2023.
//

import Foundation

protocol Updating { func update() }

extension EventDetailsViewController: Updating {
    func update() {
        viewModel = factory.makeEventDetailsViewModel()

        for child in children {
            if let child = child as? Updating { child.update() }
        }
    }
}

extension EventsListViewController: Updating { func update() { viewModel = factory.makeEventsListViewModel() }}
extension WeekViewController: Updating { func update() { viewModel = factory.makeWeekViewModel() }}
extension SummaryViewController: Updating { func update() { viewModel = factory.makeSummaryViewModel() }}
extension ClockViewController: Updating { func update() { viewModel = factory.makeClockViewModel() }}
extension DayDetailsViewController: Updating { func update() {
    viewModel = factory.makeDayDetailsViewModel(pickerDate: viewModel?.pickerDate)
}}

extension DayOfWeekController: Updating { func update() {
    viewModel = factory.makeDayOfWeekViewModel()
}}

extension EventsSortingController: Updating { func update() {
    viewModel = factory.makeEventsSortingViewModel()
}}

extension HourDistributionController: Updating {
    func update() {
        viewModel = factory.makeHourDistributionViewModel()
    }
}
