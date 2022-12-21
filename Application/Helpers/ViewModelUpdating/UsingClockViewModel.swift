//
//  ClockViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 15.12.2022.
//

import Domain

protocol UsingClockViewModel {
    var viewModel: ClockViewModel { get }
    func update(viewModel: ClockViewModel)
}

protocol ClockViewModelUpdateDispatcher {
    func addUpdateReceiver(_: UsingClockViewModel)
}

class EventsCommandingClockViewModelUpdatingDecorator:
    MulticastDelegate<UsingClockViewModel>,
    ClockViewModelUpdateDispatcher,
    EventsCommanding
{
    let decoratedInterface: EventsCommanding

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

    func addUpdateReceiver(_ receiver: UsingClockViewModel) {
        addDelegate(receiver)
    }

    private func sendUpdates(for updatedEvent: Event) {
        call { viewModelUpdateReceiver in
            if viewModelUpdateReceiver.viewModel.eventId == updatedEvent.id {
                viewModelUpdateReceiver.update(
                    viewModel: viewModelUpdateReceiver.viewModel.copy(forNewEvent: updatedEvent)
                )
            }
        }
    }
}
