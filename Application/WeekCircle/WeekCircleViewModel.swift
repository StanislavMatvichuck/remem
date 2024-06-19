//
//  WeekCircleViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.06.2024.
//

import Domain
import Foundation

struct WeekCircleViewModel: CircularViewModeling {
    let rotationAngle = 7.5 * CGFloat.pi / 7
    let vertices: [CircularVertex]

    init(reader: EventsReading, eventId: String) {
        let event = reader.read(byId: eventId)

        var happeningsByWeekDay = Array(repeating: 0, count: 7)
        var vertices = [CircularVertex]()

        /// O(n) cycle
        for happening in event.happenings {
            if let weekDayFromCalendar = WeekDay(date: happening.dateCreated) {
                happeningsByWeekDay[weekDayFromCalendar.index] += 1
            }
        }

        let maximumValue = CGFloat(happeningsByWeekDay.max()!)

        for (index, happeningsCount) in happeningsByWeekDay.enumerated() {
            let value = CGFloat(happeningsCount)
            vertices.append(CircularVertex(
                text: WeekDay(index: index).shortName,
                value: value == 0 ? 0 : value / maximumValue
            ))
        }

        self.vertices = vertices
    }
}
