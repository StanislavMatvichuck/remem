//
//  WeekList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Foundation

struct WeekList {
    let days: [WeekDay]

    init(from: Date, to: Date, happenings: [Happening]) {
        let dayDurationInSeconds: TimeInterval = 60*60*24
        var days: [WeekDay] = []

        for date in stride(from: from, to: to, by: dayDurationInSeconds) {
            let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date)
            var weekDay = WeekDay(date: components)

            for happening in happenings {
                guard let weekDayDate = Calendar.current.date(from: components) else { continue }
                if happening.dateCreated.isInSameDay(as: weekDayDate) { weekDay.amount += 1 }
            }

            days.append(weekDay)
        }

        self.days = days
    }
}
