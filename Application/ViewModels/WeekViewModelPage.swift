//
//  WeekViewModelPage.swift
//  Application
//
//  Created by Stanislav Matvichuck on 02.05.2023.
//

import Domain
import Foundation

struct WeekViewModelPage {
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = "= "
        return formatter
    }()

    let sum: String
    let goal: String?
    let percentage: String?
    let progress: CGFloat
    let goalEditable: Bool

    init(weekDate: Date, event: Event, goalEditable: Bool) {
        let sum = event.happeningsAmount(forWeekAt: weekDate)
        let sumString = String(sum)
        let goalAmount = event.weeklyGoalAmount(at: weekDate)
        let progress = CGFloat(sum) / CGFloat(goalAmount)
        let progressString = Self.formatter.string(from: progress as NSNumber)

        self.sum = sumString
        self.goal = goalAmount == 0 ? nil : String(goalAmount)
        self.percentage = goalAmount == 0 ? nil : progressString
        self.progress = progress
        self.goalEditable = goalEditable
    }
}
