//
//  EventCreationContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

import UIKit

final class EventCreationContainer: ControllerFactoring {
    private let parent: ApplicationContainer

    init(parent: ApplicationContainer) {
        self.parent = parent
    }

    func make() -> UIViewController {
        EventCreationController()
    }
}
