//
//  ViewModelUpdating.swift
//  Application
//
//  Created by Stanislav Matvichuck on 21.12.2022.
//

import Domain

struct EventDependantViewModelParameterObject { let event: Event }

protocol EventDependantViewModel {
    var eventId: String { get }
    func copy(_: EventDependantViewModelParameterObject) -> Self
}

extension EventDependantViewModel {
    func isUpdateRequired(viewModel: Self) -> Bool {
        eventId == viewModel.eventId
    }
}

protocol UsingEventDependantViewModel: AnyObject {
    associatedtype T: EventDependantViewModel
    var viewModel: T { get set }
}

extension UsingEventDependantViewModel {
    func update(viewModel: T) { self.viewModel = viewModel }
}

protocol EventUpdater {
    associatedtype T: UsingEventDependantViewModel
    func addReceiver(receiver: T)
}

class Updater<T: UsingEventDependantViewModel>:
    MulticastDelegate<T>,
    EventUpdater,
    EventsCommanding
{
    private let decoratedInterface: EventsCommanding

    init(decoratedInterface: EventsCommanding) {
        self.decoratedInterface = decoratedInterface
    }

    func save(_ event: Event) {
        decoratedInterface.save(event)
        sendUpdates(forNewEvent: event)
    }

    func delete(_ event: Event) {
        decoratedInterface.delete(event)
        sendUpdates(forNewEvent: event)
    }

    func addReceiver(receiver: T) {
        addDelegate(receiver)
    }

    func sendUpdates(forNewEvent: Event) {
        call { receiver in
            let newVM = receiver.viewModel.copy(EventDependantViewModelParameterObject(event: forNewEvent))

            if receiver.viewModel.isUpdateRequired(viewModel: newVM) {
                receiver.update(viewModel: newVM)
            }
        }
    }
}

class EventsListUpdater: Updater<EventsListViewController> {
    init(_ decoratedInterface: EventsCommanding) {
        super.init(decoratedInterface: decoratedInterface)
    }
}

class DayUpdater: Updater<DayViewController> {
    init(_ decoratedInterface: EventsCommanding) {
        super.init(decoratedInterface: decoratedInterface)
    }
}

class ClockUpdater: Updater<ClockViewController> {
    init(_ decoratedInterface: EventsCommanding) {
        super.init(decoratedInterface: decoratedInterface)
    }
}

class WeekUpdater: Updater<WeekViewController> {
    init(_ decoratedInterface: EventsCommanding) {
        super.init(decoratedInterface: decoratedInterface)
    }
}
