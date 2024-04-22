//
//  WidgetUpdateService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.04.2024.
//

import Domain

final class WidgetUpdateService: ApplicationService {
    var eventsListOrderingSubscription: DomainEventsPublisher.DomainEventSubscription?
    var happeningCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var happeningDeletedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var eventRemovedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var eventCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalCreatedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalDeletedSubscription: DomainEventsPublisher.DomainEventSubscription?
    var goalUpdatedSubscription: DomainEventsPublisher.DomainEventSubscription?

    let eventsProvider: EventsListViewModelFactoring

    init(provider: EventsListViewModelFactoring) {
        self.eventsProvider = provider

        self.eventsListOrderingSubscription = DomainEventsPublisher.shared.subscribe(
            EventsListOrderingSet.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
        self.happeningCreatedSubscription = DomainEventsPublisher.shared.subscribe(
            HappeningCreated.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
        self.happeningDeletedSubscription = DomainEventsPublisher.shared.subscribe(
            HappeningRemoved.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
        self.eventRemovedSubscription = DomainEventsPublisher.shared.subscribe(
            EventRemoved.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
        self.eventCreatedSubscription = DomainEventsPublisher.shared.subscribe(
            EventCreated.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
        self.goalCreatedSubscription = DomainEventsPublisher.shared.subscribe(
            GoalCreated.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
        self.goalDeletedSubscription = DomainEventsPublisher.shared.subscribe(
            GoalDeleted.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
        self.goalUpdatedSubscription = DomainEventsPublisher.shared.subscribe(
            GoalValueUpdated.self,
            usingBlock: { [weak self] _ in self?.serve(ApplicationServiceEmptyArgument()) }
        )
    }

    deinit {
        eventsListOrderingSubscription = nil
        happeningCreatedSubscription = nil
        happeningDeletedSubscription = nil
        eventRemovedSubscription = nil
        eventCreatedSubscription = nil
        goalCreatedSubscription = nil
        goalDeletedSubscription = nil
        goalUpdatedSubscription = nil
    }

    func serve(_: ApplicationServiceEmptyArgument) {
        let viewModel = eventsProvider.makeEventsListViewModel()

        let widgetUpdater = WidgetController()

        widgetUpdater.update(viewModel)
    }
}
