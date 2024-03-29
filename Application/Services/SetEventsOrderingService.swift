//
//  SetEventsOrderingService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.03.2024.
//

import Domain
import Foundation

protocol SetEventsOrderingServiceFactoring {
    func makeSetEventsOrderingService() -> SetEventsOrderingService
}

struct SetEventsOrderingServiceArgument {
    let eventsIdentifiersOrder: [String]?
    let ordering: EventsSorter
}

struct SetEventsOrderingService: ApplicationService {
    private let orderingRepository: EventsSortingCommanding
    private let manualOrderingRepository: EventsSortingManualCommanding

    public init(
        orderingRepository: EventsSortingCommanding,
        manualOrderingRepository: EventsSortingManualCommanding
    ) {
        self.orderingRepository = orderingRepository
        self.manualOrderingRepository = manualOrderingRepository
    }

    func serve(_ arg: SetEventsOrderingServiceArgument) {
        switch arg.ordering {
        case .name:
            orderingRepository.set(.name)
        case .dateCreated:
            orderingRepository.set(.dateCreated)
        case .total:
            orderingRepository.set(.total)
        case .manual:
            if let manualOrdering = arg.eventsIdentifiersOrder {
                manualOrderingRepository.set(manualOrdering)
            }
            orderingRepository.set(.manual)
        }

        DomainEventsPublisher.shared.publish(EventsListOrderingSet())
    }
}
