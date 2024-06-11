//
//  GoalsPresenterContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import Domain
import Foundation

final class GoalsPresenterContainer: GoalsPresenterViewModelFactoring {
    let parent: EventDetailsContainer
    
    init(_ parent: EventDetailsContainer) { self.parent = parent }
    
    func makeGoalsPresenterController() -> GoalsPresenterController {
        GoalsPresenterController(view: makeView())
    }
    
    func makeView() -> GoalsPresenterView { GoalsPresenterView(
        showGoalsService: makeShowGoalsService(),
        vmFactory: self
    ) }
    
    func makeGoalsPresenterViewModel() -> GoalsPresenterViewModel { GoalsPresenterViewModel(
        goalsReader: parent.parent.goalsReader,
        eventId: parent.eventId
    ) }
    
    func makeShowGoalsService() -> ShowGoalsService {
        ShowGoalsService(
            coordinator: parent.parent.coordinator,
            factory: GoalsContainer(parent)
        )
    }
}
