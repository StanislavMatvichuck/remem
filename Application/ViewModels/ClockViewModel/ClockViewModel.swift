//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

struct ClockViewModel {
    static let size = 144
    static let endSeconds = 24 * 60 * 60

    var sections: [ClockSection]

    init(happenings: [Happening]) {
        sections = Array(repeating: ClockSection(), count: Self.size)
        happenings.forEach { add(happening: $0) }
    }

    func section(at index: Int) -> ClockSection? {
        guard
            index < sections.count,
            index >= 0
        else { return nil }

        return sections[index]
    }

    private mutating func add(happening: Happening) {
        let date = happening.dateCreated
        guard
            let index = index(for: seconds(for: date)),
            var section = section(at: index)
        else { return }
        section.addHappening()
        sections[index] = section
    }

    private func index(for seconds: Int) -> Int? {
        guard
            seconds >= 0,
            seconds <= Self.endSeconds
        else { return nil }

        let secondsPerSection = Self.endSeconds / Self.size

        for i in 1 ... Self.size {
            if seconds <= i * secondsPerSection {
                return i - 1
            }
        }

        return nil
    }

    private func seconds(for date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)

        let hoursAsSeconds = (components.hour ?? 0) * 60 * 60
        let minutesAsSeconds = (components.minute ?? 0) * 60
        let seconds = (components.second ?? 0)

        return hoursAsSeconds + minutesAsSeconds + seconds
    }
}
