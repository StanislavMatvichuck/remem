//
//  Updating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 11.03.2023.
//

import Foundation

protocol Updating { func update() }

extension EventDetailsController: Updating {
    func update() {
        viewModel = factory.makeEventDetailsViewModel()

        for child in children {
            if let child = child as? Updating { child.update() }
        }
    }
}

extension EventsListController: Updating { func update() { viewModel = factory.makeEventsListViewModel() }}
extension WeekController: Updating { func update() {
    loadingHandler.load(for: viewRoot, factory: factory)
}}
extension SummaryController: Updating { func update() {
    loadingHandler.load(for: viewRoot, factory: factory)
}}

extension GoalsController: Updating { func update() {
    viewModel = factory.makeGoalsViewModel()
}}
extension DayDetailsController: Updating { func update() {
    viewModel = factory.makeDayDetailsViewModel(pickerDate: viewModel?.pickerDate)
}}

extension DayOfWeekController: Updating { func update() {
    loadingHandler.load(for: viewRoot, factory: factory)
}}

extension EventsSortingController: Updating { func update() {
    viewModel = factory.makeEventsSortingViewModel()
}}

extension HourDistributionController: Updating {
    func update() {
        loadingHandler.load(for: viewRoot, factory: factory)
    }
}
