//
//  WeekList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Foundation

struct WeekList {
    let days: [WeekDay]

    init(from: Date, to: Date, event: Event) {
        let dayDurationInSeconds: TimeInterval = 60*60*24
        var days: [WeekDay] = []

        for date in stride(from: from, to: to, by: dayDurationInSeconds) {
            var endOfTheDayComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            endOfTheDayComponents.hour = 23
            endOfTheDayComponents.minute = 59
            endOfTheDayComponents.second = 59

            guard let endOfTheDayDate = Calendar.current.date(from: endOfTheDayComponents) else { continue }

            let happenings = event.happenings(forDay: endOfTheDayDate)
            let goal = event.goal(at: endOfTheDayDate)

            let weekDay = WeekDay(goal: goal, happenings: happenings, date: endOfTheDayDate)

            days.append(weekDay)
        }

        self.days = days
    }
}
