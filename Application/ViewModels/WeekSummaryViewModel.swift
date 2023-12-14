//
//  NewEventWeeklyGoalViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.05.2023.
//

import Domain
import Foundation

struct WeekSummaryViewModel {
    let title: String
    let amount: String
    let goal: String
    let progress: String
    let progressValue: CGFloat

    static let amountSubtitle = String(localizationId: "weeklyGoal.amount")
    static let goalSubtitle = String(localizationId: "weeklyGoal.goal")
    static let progressSubtitle = String(localizationId: "weeklyGoal.progress")
    static let goalPlaceholder = String(localizationId: "weeklyGoal.goalPlaceholder")

    let goalHidden: Bool
    let goalTappable: Bool
    let goalAchieved: Bool
    let progressHidden: Bool

    init(weekDate: Date, event: Event, weekNumber: Int, isCurrentWeek: Bool) {
        self.title = String(localizationId: "weeklyGoal.week") + " \(weekNumber + 1)"

        let amount = event.happeningsAmount(forWeekAt: weekDate)
        self.amount = "\(amount)"

        let goal = event.weeklyGoalAmount(at: weekDate)
        self.goal = "\(goal)"

        let progress = goal == 0 ? 0 : CGFloat(amount) / CGFloat(goal)
        self.progress = Self.convert(progress: progress)
        self.progressValue = progress

        self.goalHidden = !isCurrentWeek && goal == 0
        self.goalTappable = isCurrentWeek
        self.goalAchieved = progress >= 1.0
        self.progressHidden = progress == 0
    }

    private static func convert(progress: CGFloat) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.positivePrefix = ""
        let result = formatter.string(from: progress as NSNumber)
        return result?.replacingOccurrences(of: "%", with: "") ?? ""
    }
}

