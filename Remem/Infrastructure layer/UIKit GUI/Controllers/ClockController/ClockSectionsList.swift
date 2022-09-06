//
//  ClockStitchesContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockSectionsList {
    static let size = 144

    private static let endSeconds = 24 * 60 * 60

    // MARK: - Properties
    var sections: [ClockSection] = Array(repeating: ClockSection(), count: Self.size)

    init(happenings: [Happening]) {
        happenings.forEach { add(happening: $0) }
    }
}

// MARK: - Public
extension ClockSectionsList {
    func section(at index: Int) -> ClockSection? {
        guard
            index < sections.count,
            index >= 0
        else { return nil }

        return sections[index]
    }
}

// MARK: - Private
extension ClockSectionsList {
    private mutating func add(happening: Happening) {
        let date = happening.dateCreated
        guard
            let index = index(for: seconds(for: date)),
            var section = section(at: index)
        else { return }
        section.addHappening()
        sections[index] = section
    }

    private func seconds(for date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: date)

        let hoursAsSeconds = (components.hour ?? 0) * 60 * 60
        let minutesAsSeconds = (components.minute ?? 0) * 60
        let seconds = (components.second ?? 0)

        return hoursAsSeconds + minutesAsSeconds + seconds
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
}
