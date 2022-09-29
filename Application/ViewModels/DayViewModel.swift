//
//  DayViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import Foundation
import IosUseCases

public protocol DayViewModeling:
    DayViewModelState &
    DayViewModelEvents {}

public protocol DayViewModelState {
    var title: String? { get }
    var date: Date { get }
    func time(at: Int) -> String
    var count: Int { get }
}

public protocol DayViewModelEvents {
    func remove(at: Int)
    func add(at: Date)
}

public class DayViewModel: DayViewModeling {
    // MARK: - Properties
    public weak var delegate: DayViewModelDelegate?

    public let date: Date
    private var event: Event
    private let editUseCase: EventEditUseCasing
    private var shownHappenings: [Happening] { event.happenings(forDay: date) }
    // MARK: - Init
    public init(date: Date, event: Event, editUseCase: EventEditUseCasing) {
        func updateTimeToCurrent(forDate: Date) -> Date {
            let c = Calendar.current
            let currentDate = Date.now
            let componentsWithCurrentTime = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
            var componentsToBeChanged = c.dateComponents([.year, .month, .day, .hour, .minute, .second], from: forDate)
            componentsToBeChanged.hour = componentsWithCurrentTime.hour
            componentsToBeChanged.minute = componentsWithCurrentTime.minute
            return c.date(from: componentsToBeChanged)!
        }

        self.date = updateTimeToCurrent(forDate: date)
        self.event = event
        self.editUseCase = editUseCase
    }

    // DayViewModelState
    public var title: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM"
        return dateFormatter.string(for: date)
    }

    public var count: Int { shownHappenings.count }

    public func time(at: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none

        let happeningDate = shownHappenings[at].dateCreated
        return dateFormatter.string(from: happeningDate)
    }

    // DayViewModelEvents
    public func remove(at: Int) {
        // this consist of error in time by day
        let happening = event.happenings(forDay: date)[at]
        editUseCase.removeHappening(from: event, happening: happening)
    }

    public func add(at: Date) {
        editUseCase.addHappening(to: event, date: at)
    }
}

extension DayViewModel: EventEditUseCasingDelegate {
    public func added(happening: Happening, to: Event) {
        event = to
        delegate?.update()
    }

    public func removed(happening: Happening, from: Event) {
        event = from
        delegate?.update()
    }

    public func renamed(event: Event) {}
    public func visited(event: Event) {}
    public func added(goal: Goal, to: Event) {}
}

public protocol DayViewModelDelegate: AnyObject {
    func update()
}
