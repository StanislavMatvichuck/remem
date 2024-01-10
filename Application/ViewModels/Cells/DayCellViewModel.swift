//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayCellViewModel {
    typealias RemoveHandler = (Happening) -> Void

    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    private let removeHandler: RemoveHandler
    private let happening: Happening

    let time: String

    init(happening: Happening, remove: @escaping RemoveHandler) {
        self.happening = happening
        self.time = Self.formatter.string(from: happening.dateCreated)
        self.removeHandler = remove
    }

    func remove() { removeHandler(happening) }
}
