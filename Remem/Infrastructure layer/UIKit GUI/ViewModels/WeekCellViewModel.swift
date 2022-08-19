//
//  WeekCellViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.08.2022.
//

import UIKit

class WeekCellViewModel: NSObject {
    typealias View = WeekCell
    typealias Model = WeekDay

    // MARK: - Properties
    private let model: Model
    private weak var view: View?

    // testable data
    private var goalsAmount: Int
    private var happeningsTimings: [String]
    private var isAchieved: Bool

    // MARK: - Init
    init(model: Model) {
        self.model = model

        goalsAmount = model.goal?.amount ?? 0

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        happeningsTimings = model.happenings.map { happening in
            formatter.string(from: happening.dateCreated)
        }

        isAchieved = happeningsTimings.count >= goalsAmount && goalsAmount > 0
    }
}

// MARK: - Public
extension WeekCellViewModel {
    func configure(_ view: View) {
        self.view = view

        view.day.text = String(model.dayNumber)
        view.day.textColor = model.isToday ? UIHelper.brand : UIHelper.itemFont
        view.amount.text = String(model.happenings.count)

        view.showGoal(amount: goalsAmount)
        view.show(timings: happeningsTimings)

        if isAchieved { view.show(achievedGoalAmount: goalsAmount) }
    }
}
