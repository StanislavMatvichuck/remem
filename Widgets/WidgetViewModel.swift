//
//  WidgetViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Domain
import Foundation
import WidgetKit

struct WidgetViewModel: Codable, Equatable {
    enum CodingKeys: String, CodingKey { case items }

    var items: [WidgetRowViewModel]

    init(items: [WidgetRowViewModel]) { self.items = items }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try values.decode([WidgetRowViewModel].self, forKey: .items)
    }
}

struct WidgetRowViewModel: Codable, Equatable {
    var name: String
    var amount: String
    var hasGoal: Bool
    var goalReached: Bool
}

extension WidgetRowViewModel {
    init(event: Event, today: DayComponents) {
        self.init(
            name: event.name,
            amount: String(event.happenings(forDayComponents: today).count),
            hasGoal: false,
            goalReached: false
        )
    }
}
