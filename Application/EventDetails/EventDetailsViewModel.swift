//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Domain
import Foundation

struct EventDetailsViewModel {
    private let event: Event

    init(event: Event) { self.event = event }

    var title: String { event.name }
    var isVisited: Bool { event.dateVisited != nil }
}
