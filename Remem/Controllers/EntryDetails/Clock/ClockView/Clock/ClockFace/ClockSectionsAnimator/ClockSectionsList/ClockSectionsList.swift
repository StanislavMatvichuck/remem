//
//  ClockStitchesContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

struct ClockSectionsList {
    static let secondsPer24h = 24 * 60 * 60

    // MARK: - Properties
    let size: Int
    private let start: ClockTimeDescription
    private let end: ClockTimeDescription
    private let secondsPerSection: Int
    var sections: [ClockSection]
    private let freshPoint: Point?

    // MARK: - Init
    init(start: ClockTimeDescription, end: ClockTimeDescription, sectionsPer24h: Int, freshPoint: Point?) {
        self.start = start
        self.end = end
        self.secondsPerSection = Self.secondsPer24h / sectionsPer24h

        self.freshPoint = freshPoint

        self.size = (end.seconds - start.seconds) / secondsPerSection
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

    mutating func fill(with points: [Point]) {
        reset()
        points.forEach { add(point: $0) }
    }

    var currentTimeIsInList: Bool {
        let currentSeconds = seconds(for: Date.now)

        if
            currentSeconds >= start.seconds,
            currentSeconds <= end.seconds
        {
            return true
        }

        return false
    }

    //
    // Creation
    //

    static func makeForClockVariant(_ variant: ClockController.ClockVariant, freshPoint: Point?) -> ClockSectionsList {
        switch variant {
        case .day: return .makeForDayClock(freshPoint: freshPoint)
        case .night: return .makeForNightClock(freshPoint: freshPoint)
        }
    }

    static func makeForDayClock(freshPoint: Point?) -> ClockSectionsList {
        return ClockSectionsList(start: .makeMidday(), end: .makeEndOfDay(), sectionsPer24h: 144, freshPoint: freshPoint)
    }

    static func makeForNightClock(freshPoint: Point?) -> ClockSectionsList {
        return ClockSectionsList(start: .makeStartOfDay(), end: .makeMidday(), sectionsPer24h: 144, freshPoint: freshPoint)
    }
}

// MARK: - Private
extension ClockSectionsList {
    private mutating func add(point: Point) {
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
            if seconds <= start.seconds + i * secondsPerSection {
                return i - 1
            }
        }

        return nil
    }

    private static func makeEmpty(size: Int) -> [ClockSection] {
        Array(repeating: ClockSection(), count: size)
    }
}
