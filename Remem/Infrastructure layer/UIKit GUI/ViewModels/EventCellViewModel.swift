//
//  EventCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.08.2022.
//

import Foundation

protocol EventCellViewModelInput:
    EventCellViewModelInputState &
    EventCellViewModelInputEvents {}

class EventCellViewModel: EventCellViewModelInput {
    // MARK: - Private
    let event: Event
    weak var delegate: EventsListViewModelInputEvents?
    weak var view: EventCellViewModelOutput?
    // MARK: - Init
    init(event: Event, delegate: EventsListViewModelInputEvents, view: EventCellViewModelOutput) {
        self.event = event
        self.delegate = delegate
        self.view = view
    }
}

// MARK: - EventCellViewModelInputState
protocol EventCellViewModelInputState {
    var name: String { get }
    var amount: String { get }
}

extension EventCellViewModel: EventCellViewModelInputState {
    var name: String { event.name }
    var amount: String { String(event.happenings.count) }
}

// MARK: - EventCellViewModelInputEvents
protocol EventCellViewModelInputEvents: AnyObject {
    func press()
    func swipe()
}

extension EventCellViewModel: EventCellViewModelInputEvents {
    func press() { delegate?.select(event: event) }
    func swipe() { delegate?.addHappening(to: event) }
}

// MARK: - EventCellViewModelOutput
protocol EventCellViewModelOutput: AnyObject {
    func animateAfterSwipe()
}
