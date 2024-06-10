//
//  GoalsPresenterContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import Foundation

final class GoalsPresenterContainer {
    let parent: EventDetailsContainer
    
    init(_ parent: EventDetailsContainer) {
        self.parent = parent
    }
    
    func makeGoalsPresenterController() -> GoalsPresenterController {
        GoalsPresenterController(view: makeView())
    }
    
    func makeView() -> GoalsPresenterView { 
        GoalsPresenterView(
        showGoalsService: makeShowGoalsService()
    )}
    
    func makeShowGoalsService() -> ShowGoalsService {
        ShowGoalsService(
            coordinator: parent.parent.coordinator,
            factory: GoalsContainer(parent)
        )
    }
}
