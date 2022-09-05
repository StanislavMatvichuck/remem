//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import Foundation

protocol WeekViewModelInput:
    WeekViewModelState &
    WeekViewModelEvents {}

protocol WeekViewModelState {
    func cellViewModel(at: Int) -> WeekCellViewModel?
    var count: Int { get }
}

protocol WeekViewModelEvents {}

class WeekViewModel: WeekViewModelInput {
    static let shownDaysForward = 14
    // MARK: - Properties
    weak var delegate: WeekViewModelOutput?
    weak var coordinator: Coordinator?

    private var event: Event
    private let factory: WeekFactoryInterface
    private var weekCellViewModels: [WeekCellViewModel]
    // MARK: - Init
    init(event: Event, factory: WeekFactoryInterface) {
        self.event = event
        self.factory = factory
        self.weekCellViewModels = makeWeekCellViewModels()

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
    func cellViewModel(at index: Int) -> WeekCellViewModel? {
        guard index < weekCellViewModels.count, index >= 0 else { return nil }
        let date = weekCellViewModels[index].date
        return factory.makeWeekCellViewModel(date: date)
    }

    var count: Int { weekCellViewModels.count }
}

// MARK: - EventEditUseCaseOutput
extension WeekViewModel: EventEditUseCaseOutput {
    func added(happening: Happening, to: Event) {
        event = to
        delegate?.update()
    }

    func removed(happening: Happening, from: Event) {
        event = from
        delegate?.update()
    }

    func added(goal: Goal, to: Event) {
        event = to
        delegate?.update()
    }

    func renamed(event: Event) {}
    func visited(event: Event) {}
}

protocol WeekViewModelOutput: AnyObject {
    func animate(at: IndexPath)
    func update()
}
