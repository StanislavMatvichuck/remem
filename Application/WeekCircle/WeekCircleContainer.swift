//
//  WeekCircleContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.06.2024.
//

import Foundation

final class WeekCircleContainer: WeekCircleViewModelFactoring {
    private let parent: EventDetailsContainer
    
    init(_ parent: EventDetailsContainer) { self.parent = parent }
    
    func makeWeekCircleController() -> WeekCircleController {
        let viewModel = makeViewModel()
        
        return WeekCircleController(
            view: makeView(viewModel: viewModel),
            viewModel: viewModel,
            viewModelFactory: self
        )
    }
    
    func makeView(viewModel: WeekCircleViewModel) -> WeekCircleView {
        WeekCircleView(viewModel: viewModel)
    }
    
    func makeViewModel() -> WeekCircleViewModel {
        WeekCircleViewModel(
            reader: parent.parent.eventsReader,
            eventId: parent.eventId
        )
    }
}
