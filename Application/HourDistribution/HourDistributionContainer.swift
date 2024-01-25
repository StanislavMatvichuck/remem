//
//  HourDistributionContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionContainer: ControllerFactoring {
    private let parent: EventDetailsContainer

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func make() -> UIViewController {
        HourDistributionController()
    }
}
