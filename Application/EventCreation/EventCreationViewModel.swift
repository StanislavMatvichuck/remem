//
//  EventCreationViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.01.2024.
//

import Foundation

struct EventCreationViewModel {
    static let hint = String(localizationId: "eventsList.new")

    let emoji: [String] = ["📖", "👟", "☕️", "🚬", "💊", "📝", "🪴", "🍷", "🍭"]
    var createdEventName = ""

    mutating func handle(emoji: Int) { createdEventName += self.emoji[emoji] }
}
