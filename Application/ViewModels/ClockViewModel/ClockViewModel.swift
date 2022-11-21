//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import Domain
import Foundation

public class ClockViewModel {
    var event: Event { didSet {
        list = ClockSectionsList(happenings: event.happenings)
    }}

    var list: ClockSectionsList
    // MARK: - Init
    init(event: Event) {
        self.event = event
        list = ClockSectionsList(happenings: event.happenings)
    }

    func section(at: Int) -> ClockSection? { list.section(at: at) }
}
