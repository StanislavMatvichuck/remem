//
//  DayViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.12.2022.
//

import Domain

protocol DayViewModelUpdating {
    var currentViewModel: DayViewModel { get }
    func update(viewModel: DayViewModel)
}

protocol DayViewModelUpdateDispatcher {
    func addUpdateReceiver(_: DayViewModelUpdating)
}

class EventsCommandingDayViewModelUpdatingDecorator:
    MulticastDelegate<DayViewModelUpdating>,
    DayViewModelUpdateDispatcher,
    EventsCommanding
{
    let decoratedInterface: EventsCommanding
    var viewModelFactory: ((_: Event, _: DayComponents) -> DayViewModel)?

    init(decoratedInterface: EventsCommanding) { self.decoratedInterface = decoratedInterface }

    func save(_ event: Domain.Event) {
        decoratedInterface.save(event)
        sendUpdates(for: event)
    }

    func delete(_ event: Domain.Event) {
        decoratedInterface.delete(event)
        sendUpdates(for: event)
    }

    func addUpdateReceiver(_ receiver: DayViewModelUpdating) {
        addDelegate(receiver)
    }

    private func sendUpdates(for updatedEvent: Event) {
        guard let viewModelFactory else { fatalError("viewModelFactory is not provided") }

        call { viewModelUpdateReceiver in
            let currentViewModel = viewModelUpdateReceiver.currentViewModel

            if currentViewModel.event == updatedEvent {
                let newViewModel = viewModelFactory(updatedEvent, currentViewModel.day)
                viewModelUpdateReceiver.update(viewModel: newViewModel)
            }
        }
    }
}
