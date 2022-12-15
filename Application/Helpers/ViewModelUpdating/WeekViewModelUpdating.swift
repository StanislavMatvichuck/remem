//
//  WeekViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 15.12.2022.
//

import Domain

protocol WeekViewModelUpdating {
    var currentViewModel: WeekViewModel { get }
    func update(viewModel: WeekViewModel)
}

protocol WeekViewModelUpdateDispatcher {
    func addUpdateReceiver(_: WeekViewModelUpdating)
}

class EventsCommandingWeekViewModelUpdatingDecorator:
    MulticastDelegate<WeekViewModelUpdating>,
    WeekViewModelUpdateDispatcher,
    EventsCommanding
{
    let decoratedInterface: EventsCommanding
    var viewModelFactory: ((_: Event, _: DayComponents) -> WeekViewModel)?

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

    func addUpdateReceiver(_ receiver: WeekViewModelUpdating) {
        addDelegate(receiver)
    }

    private func sendUpdates(for updatedEvent: Event) {
        guard let viewModelFactory else { fatalError("viewModelFactory is not provided") }

        call { viewModelUpdateReceiver in
            let currentViewModel = viewModelUpdateReceiver.currentViewModel

            if currentViewModel.event == updatedEvent {
                let newViewModel = viewModelFactory(updatedEvent, currentViewModel.today)
                viewModelUpdateReceiver.update(viewModel: newViewModel)
            }
        }
    }
}
