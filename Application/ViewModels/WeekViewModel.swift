//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Domain
import Foundation
import IosUseCases

public protocol WeekViewModeling:
    WeekViewModelState &
    WeekViewModelEvents {}

public protocol WeekViewModelState {
    func cellViewModel(at: Int) -> WeekCellViewModel?
    var count: Int { get }
}

public protocol WeekViewModelEvents {}

public protocol WeekFactoryInterface: AnyObject {
    func makeWeekCellViewModel(date: Date) -> WeekCellViewModel
}

public class WeekViewModel: WeekViewModeling {
    public static let shownDaysForward = 14
    // MARK: - Properties
    public weak var delegate: WeekViewModelDelegate?
    public weak var coordinator: Coordinating?

    private var event: Event
    private let factory: WeekFactoryInterface
    private var weekCellViewModels: [WeekCellViewModel]
    private let multicastDelegate: MulticastDelegate<GoalEditUseCaseDelegate>
    // MARK: - Init
    public init(event: Event, factory: WeekFactoryInterface, multicastDelegate: MulticastDelegate<GoalEditUseCaseDelegate>) {
        self.event = event
        self.factory = factory
        self.weekCellViewModels = makeWeekCellViewModels()
        self.multicastDelegate = multicastDelegate

        func makeWeekCellViewModels() -> [WeekCellViewModel] {
            let from = event.dateCreated.startOfWeek!
            let futureDays = Double(60*60*24*Self.shownDaysForward)
            let to = Date.now.endOfWeek!.addingTimeInterval(futureDays)

            let dayDurationInSeconds: TimeInterval = 60*60*24
            var viewModels = [WeekCellViewModel]()

            for date in stride(from: from, to: to, by: dayDurationInSeconds) {
                var endOfTheDayComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                endOfTheDayComponents.hour = 23
                endOfTheDayComponents.minute = 59
                endOfTheDayComponents.second = 59

                guard let endOfTheDayDate = Calendar.current.date(from: endOfTheDayComponents) else { continue }
                let viewModel = factory.makeWeekCellViewModel(date: endOfTheDayDate)
                viewModels.append(viewModel)
            }

            return viewModels
        }
    }

    // WeekViewModelState
    public func cellViewModel(at index: Int) -> WeekCellViewModel? {
        guard index < weekCellViewModels.count, index >= 0 else { return nil }
        let date = weekCellViewModels[index].date
        let viewModel = factory.makeWeekCellViewModel(date: date)
        multicastDelegate.addDelegate(viewModel)
        return viewModel
    }

    public var count: Int { weekCellViewModels.count }
}

// MARK: - EventEditUseCaseDelegate
extension WeekViewModel: EventEditUseCaseDelegate {
    public func added(happening: Happening, to: Event) {
        event = to
        delegate?.update()
    }

    public func removed(happening: Happening, from: Event) {
        event = from
        delegate?.update()
    }

    public func added(goal: Goal, to: Event) {
        event = to
        delegate?.update()
    }

    public func renamed(event: Event) {}
    public func visited(event: Event) {}
}

extension WeekViewModel: GoalEditUseCaseDelegate {
    public func update(amount: Int, forDay: Domain.Goal.WeekDay) {
        multicastDelegate.call { $0.update(amount: amount, forDay: forDay) }
    }

    public func dismiss() {
        multicastDelegate.call { $0.dismiss() }
    }
}

public protocol WeekViewModelDelegate: AnyObject {
    func animate(at: IndexPath)
    func update()
}
