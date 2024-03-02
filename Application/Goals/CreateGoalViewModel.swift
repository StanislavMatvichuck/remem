//
//  CreateGoalViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.02.2024.
//

import Foundation

struct CreateGoalViewModel {
    static let createGoal = String(localizationId: "goals.create")
    typealias TapHandler = () -> Void

    private let handler: TapHandler?

    init(handler: TapHandler? = nil) { self.handler = handler }

    func handleTap() { handler?() }
}
