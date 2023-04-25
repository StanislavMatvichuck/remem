//
//  ExtenstionEventsQuerySorter.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import Domain

extension EventsQuerySorter {
    var title: String {
        switch self {
        case .alphabetical: return String(localizationId: "eventsList.ordering.alphabetically")
        case .happeningsCountTotal: return String(localizationId: "eventsList.ordering.totalHappenings")
        }
    }
}
