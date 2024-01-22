//
//  EventCreationViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.01.2024.
//

import Foundation

struct EventCreationViewModel {
    static let hint = String(localizationId: "eventsList.new")

    typealias SubmitHandler = (String) -> Void

    let emoji: [String] = ["📖", "👟", "☕️", "🚬", "💊", "📝", "🪴", "🍷", "🍭"]
    var createdEventName = ""

    private let submitHandler: SubmitHandler?

    init(submitHandler: SubmitHandler? = nil) {
        self.submitHandler = submitHandler
    }

    func submit() {
        guard createdEventName.count > 0 else { return }
        submitHandler?(createdEventName)
    }
}
