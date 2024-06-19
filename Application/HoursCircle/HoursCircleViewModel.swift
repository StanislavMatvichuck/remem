//
//  HoursCircleViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.06.2024.
//

import Domain
import Foundation

struct HoursCircleViewModel: CircularViewModeling {
    private static let hoursCount = 24

    let rotationAngle = -13 * CGFloat.pi / 24
    let vertices: [CircularVertex]

    init(reader: EventsReading, eventId: String) {
        let event = reader.read(byId: eventId)

        var hoursValues = Array(repeating: 0, count: Self.hoursCount)

        /// O(n) cycle
        for happening in event.happenings {
            guard let happeningHour = Calendar.current.dateComponents([.hour], from: happening.dateCreated).hour else { continue }
            hoursValues[happeningHour] += 1
        }

        let hoursMaximum = CGFloat(hoursValues.max()!)

        var vertices = [CircularVertex]()

        for hour in 0 ..< Self.hoursCount {
            let hourValue = CGFloat(hoursValues[hour])
            vertices.append(CircularVertex(
                text: "\(hour)",
                value: hourValue == 0 ? 0 : hourValue / hoursMaximum
            ))
        }

        self.vertices = vertices
    }
}
