//
//  WidgetViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Domain
import Foundation
import WidgetKit

protocol WidgetViewModeling: TimelineEntry {
    var date: Date { get }

    var count: Int { get }
    func rowViewModel(at: Int) -> WidgetRowViewModeling?
}

 protocol WidgetRowViewModeling {
    var name: String { get }
    var amount: String { get }
    var hasGoal: Bool { get }
    var goalReached: Bool { get }
}

 struct WidgetViewModel: WidgetViewModeling, Codable, Equatable {
    // MARK: - Properties
     var date: Date
     var viewModel: [WidgetRowViewModel]

    // MARK: - Init
     init(date: Date, viewModel: [WidgetRowViewModel]) {
        self.date = date
        self.viewModel = viewModel
    }

    // MARK: - WidgetViewModeling
     var count: Int { viewModel.count }
     func rowViewModel(at index: Int) -> WidgetRowViewModeling? {
        guard index < viewModel.count, index >= 0 else { return nil }
        return viewModel[index]
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case date
        case viewModel
    }

     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(viewModel, forKey: .viewModel)
    }

     init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.date = try values.decode(Date.self, forKey: .date)
        self.viewModel = try values.decode([WidgetRowViewModel].self, forKey: .viewModel)
    }
}

 struct WidgetRowViewModel: WidgetRowViewModeling, Codable, Equatable {
     var name: String
     var amount: String
     var hasGoal: Bool
     var goalReached: Bool
     init(name: String, amount: String, hasGoal: Bool, goalReached: Bool) {
        self.name = name
        self.amount = amount
        self.hasGoal = hasGoal
        self.goalReached = goalReached
    }
}
