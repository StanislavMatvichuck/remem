//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayCellViewModel: Equatable, Hashable {
    typealias RemoveHandler = (Happening) -> Void

    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    private let identifier: Int
    private let removeHandler: RemoveHandler
    private let happening: Happening

    let time: String

    init(index: Int, happening: Happening, remove: @escaping RemoveHandler) {
        self.identifier = index
        self.happening = happening
        self.time = Self.formatter.string(from: happening.dateCreated)
        self.removeHandler = remove
    }

    func remove() { removeHandler(happening) }

    static func == (lhs: DayCellViewModel, rhs: DayCellViewModel) -> Bool {
        lhs.happening.dateCreated == rhs.happening.dateCreated &&
            lhs.identifier == rhs.identifier
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(happening.dateCreated)
        hasher.combine(identifier)
    }
}
