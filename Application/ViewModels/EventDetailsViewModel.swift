//
//  EventDetailsViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.08.2022.
//

import Domain
import Foundation

struct EventDetailsViewModel {
    typealias VisitHandler = (Event) -> Void

    let visitHandler: VisitHandler

    private let event: Event

    init(event: Event, visitHandler: @escaping VisitHandler) {
        self.event = event
        self.visitHandler = visitHandler
    }

    var title: String { event.name }
    var isVisited: Bool { event.dateVisited != nil }

    func visit() {
        if event.dateVisited == nil { visitHandler(event) }
    }
}
