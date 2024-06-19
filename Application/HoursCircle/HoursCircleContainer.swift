//
//  HoursCircleContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.06.2024.
//

import Foundation

final class HoursCircleContainer: HoursCircleViewModelFactoring {
    private let parent: EventDetailsContainer
    
    init(_ parent: EventDetailsContainer) { self.parent = parent }
    
    func makeHoursCircleController() -> HoursCircleController {
        let viewModel = makeViewModel()
        return HoursCircleController(
            view: makeView(viewModel: viewModel),
            viewModel: viewModel,
            viewModelFactory: self
        )
    }
    
    func makeView(viewModel: HoursCircleViewModel) -> HoursCircleView {
        HoursCircleView(viewModel: viewModel)
    }
    
    func makeViewModel() -> HoursCircleViewModel {
        HoursCircleViewModel(
            reader: parent.parent.eventsReader,
            eventId: parent.eventId
        )
    }
}
