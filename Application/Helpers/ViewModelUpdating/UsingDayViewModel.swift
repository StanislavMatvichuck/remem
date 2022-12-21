//
//  DayViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 13.12.2022.
//

import Domain

protocol UsingDayViewModel {
    var viewModel: DayViewModel { get }
    func update(viewModel: DayViewModel)
}

protocol DayViewModelUpdateDispatcher {
    func addUpdateReceiver(_: UsingDayViewModel)
}

class EventsCommandingDayViewModelUpdatingDecorator:
    MulticastDelegate<UsingDayViewModel>,
    DayViewModelUpdateDispatcher,
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

    func addUpdateReceiver(_ receiver: UsingDayViewModel) {
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
