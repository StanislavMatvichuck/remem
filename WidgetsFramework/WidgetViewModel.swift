//
//  WidgetViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Foundation
import WidgetKit

public protocol WidgetViewModeling: TimelineEntry {
    var date: Date { get }

    var count: Int { get }
    func rowViewModel(at: Int) -> WidgetRowViewModeling?
}

public protocol WidgetRowViewModeling {
    var name: String { get }
    var amount: String { get }
    var hasGoal: Bool { get }
    var goalReached: Bool { get }
}

public struct WidgetViewModel: WidgetViewModeling, Codable, Equatable {
    // MARK: - Properties
    public var date: Date
    private var viewModel: [WidgetRowViewModel]

    // MARK: - Init
    public init(date: Date, viewModel: [WidgetRowViewModel]) {
        self.date = date
        self.viewModel = viewModel
    }

    // MARK: - WidgetViewModeling
    public var count: Int { viewModel.count }
    public func rowViewModel(at index: Int) -> WidgetRowViewModeling? {
        guard index < viewModel.count, index >= 0 else { return nil }
        return viewModel[index]
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case date
        case viewModel
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(viewModel, forKey: .viewModel)
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.date = try values.decode(Date.self, forKey: .date)
        self.viewModel = try values.decode([WidgetRowViewModel].self, forKey: .viewModel)
    }
}

public struct WidgetRowViewModel: WidgetRowViewModeling, Codable, Equatable {
    public var name: String
    public var amount: String
    public var hasGoal: Bool
    public var goalReached: Bool
    public init(name: String, amount: String, hasGoal: Bool, goalReached: Bool) {
        self.name = name
        self.amount = amount
        self.hasGoal = hasGoal
        self.goalReached = goalReached
    }
}
