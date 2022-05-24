//
//  ClockStitchesContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.05.2022.
//

import Foundation

class ClockSectionDescriptionsList {
    let size: Int

    private static let secondsPer24h = 24 * 60 * 60

    private let start: ClockTimeDescription
    private let end: ClockTimeDescription
    private let stitchesPer24h: Int
    private let secondsPerStitch: Int
    private lazy var descriptions: [ClockSectionDescription] = makeEmptyDescriptionsArray()

    init(start: ClockTimeDescription, end: ClockTimeDescription, stitchesPer24h: Int) {
        self.start = start
        self.end = end
        self.stitchesPer24h = stitchesPer24h
        self.secondsPerStitch = Self.secondsPer24h / stitchesPer24h
        self.size = (end.seconds - start.seconds) / secondsPerStitch
    }
}

// MARK: - Public
extension ClockSectionDescriptionsList {
    func description(at index: Int) -> ClockSectionDescription? {
        guard index < size, index >= 0 else { return nil }
        return descriptions[index]
    }

    func addPoint(with date: Date) {
        let pointSeconds = seconds(for: date)
        if let index = index(for: pointSeconds) {
            addPoint(at: index)
        }
    }

    func reset() {
        descriptions = makeEmptyDescriptionsArray()
    }
}

// MARK: - Private
extension ClockSectionDescriptionsList {
    private func addPoint(at index: Int) {
        guard var description = description(at: index) else { return }
        description.addPoint()
        descriptions[index] = description
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

    private func makeEmptyDescriptionsArray() -> [ClockSectionDescription] {
        Array(repeating: ClockSectionDescription(), count: size)
    }
}
