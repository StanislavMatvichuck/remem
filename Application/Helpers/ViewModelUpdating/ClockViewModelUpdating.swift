//
//  ClockViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 15.12.2022.
//

import Domain

protocol ClockViewModelUpdating {
    var currentViewModel: ClockViewModel { get }
    func update(viewModel: ClockViewModel)
}

protocol ClockViewModelUpdateDispatcher {
    func addUpdateReceiver(_: ClockViewModelUpdating)
}

class EventsCommandingClockViewModelUpdatingDecorator:
    MulticastDelegate<ClockViewModelUpdating>,
    ClockViewModelUpdateDispatcher,
    EventsCommanding
{
    let decoratedInterface: EventsCommanding
    var viewModelFactory: ((_: Event) -> ClockViewModel)?

    init(decoratedInterface: EventsCommanding) {
        self.decoratedInterface = decoratedInterface
    }

    func save(_ event: Domain.Event) {
        decoratedInterface.save(event)
        sendUpdates(for: event)
    }

    func delete(_ event: Domain.Event) {
        decoratedInterface.delete(event)
        sendUpdates(for: event)
    }

    func addUpdateReceiver(_ receiver: ClockViewModelUpdating) {
        addDelegate(receiver)
    }

    private func sendUpdates(for updatedEvent: Event) {
        guard let viewModelFactory else { fatalError("viewModelFactory is not provided") }

        call { viewModelUpdateReceiver in
            let currentViewModel = viewModelUpdateReceiver.currentViewModel

            if currentViewModel.event == updatedEvent {
                let newViewModel = viewModelFactory(updatedEvent)
                viewModelUpdateReceiver.update(viewModel: newViewModel)
            }
        }
    }
}
