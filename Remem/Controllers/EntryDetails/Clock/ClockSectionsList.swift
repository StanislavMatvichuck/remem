//
//  ClockStitchesContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockSectionsList {
    // MARK: - Properties
    let size: Int

    static let secondsPer24h = 24 * 60 * 60

    let start: ClockTimeDescription
    let end: ClockTimeDescription
    let stitchesPer24h: Int
    let secondsPerStitch: Int
    var sections: [ClockSection]

    // MARK: - Init
    init(start: ClockTimeDescription, end: ClockTimeDescription, sectionsPer24h: Int) {
        self.start = start
        self.end = end
        self.stitchesPer24h = sectionsPer24h
        self.secondsPerStitch = Self.secondsPer24h / sectionsPer24h
        self.size = (end.seconds - start.seconds) / secondsPerStitch
        self.sections = Self.makeEmpty(size: size)
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

    mutating func fill(with points: [Point], freshPoint: Point?) {
        reset()
        points.forEach { add(point: $0, freshPoint: freshPoint) }
    }

    //
    // Creation
    //

    static func makeForDayClock() -> ClockSectionsList {
        return ClockSectionsList(start: .makeMidday(), end: .makeEndOfDay(), sectionsPer24h: 144)
    }

    static func makeForNightClock() -> ClockSectionsList {
        return ClockSectionsList(start: .makeStartOfDay(), end: .makeMidday(), sectionsPer24h: 144)
    }
}

// MARK: - Private
extension ClockSectionsList {
    private mutating func add(point: Point, freshPoint: Point?) {
        guard
            let date = point.dateCreated,
            let index = index(for: seconds(for: date)),
            var section = section(at: index)
        else { return }

        let isFreshPoint = freshPoint != nil && point == freshPoint
        let isToday = date.isInToday

        section.addPoint()

        if isFreshPoint { section.setHasLastPoint() }
        if isToday { section.setToday() }

        sections[index] = section
    }

    private mutating func reset() {
        sections = Self.makeEmpty(size: size)
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
            seconds >= start.seconds,
            seconds <= end.seconds
        else { return nil }

        for i in 1 ... size {
            if seconds <= start.seconds + i * secondsPerStitch {
                return i - 1
            }
        }

        return nil
    }

    private static func makeEmpty(size: Int) -> [ClockSection] {
        Array(repeating: ClockSection(), count: size)
    }
}
