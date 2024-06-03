//
//  EventsListViewModelWithRepository.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.03.2024.
//

import Domain

struct EventsListViewModel {
    enum Section: Int, CaseIterable { case hint, events, createEvent }

    static let title = String(localizationId: "eventsList.title")
    static let eventsSortingLabel = String(localizationId: "eventsSorting.title")
    static let sections = Section.allCases

    private static let hintSectionIdentifier = "Hint"
    private static let createEventSectionIdentifier = "CreateEvent"

    private let list: EventsList
    private let hintVmFactory: HintCellViewModelFactoring
    private let eventVmFactory: LoadableEventCellViewModelFactoring
    private let createEventVmFactory: CreateEventCellViewModelFactoring

    var dragAndDrop = RemovalDropAreaViewModel()

    init(
        list: EventsList,
        hintFactory: HintCellViewModelFactoring,
        eventFactory: LoadableEventCellViewModelFactoring,
        createEventFactory: CreateEventCellViewModelFactoring
    ) {
        self.list = list
        self.hintVmFactory = hintFactory
        self.eventVmFactory = eventFactory
        self.createEventVmFactory = createEventFactory
    }

    // MARK: - Ordering support
    var ordering: EventsList.Ordering { list.ordering }

    func manualSortingPresentableFor(_ oldValue: EventsListViewModel?) -> Bool {
        guard let oldValue else { return false }
        return list.ordering == .manual && oldValue.list.ordering != .manual
    }

    // MARK: - DataSource
    /// Operates on stored property
    func identifiersFor(section: Section) -> [String] { switch section {
    case .hint: return [Self.hintSectionIdentifier]
    case .events: return list.eventsIdentifiers
    case .createEvent: return [Self.createEventSectionIdentifier]
    } }

    /// Operates on calculated property -> mutable
    func viewModel(forIdentifier id: String) -> (any EventsListCellViewModel)? {
        if id == Self.hintSectionIdentifier { return hintVmFactory.makeHintCellViewModel(hint: list.hint) }
        if id == Self.createEventSectionIdentifier { return createEventVmFactory.makeCreateEventCellViewModel(eventsCount: list.eventsIdentifiers.count) }
        return eventVmFactory.makeLoadingEventCellViewModel(eventId: id)
    }
}
