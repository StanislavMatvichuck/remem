//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayCellViewModel: Identifiable {
    typealias RemoveHandler = (Self, Happening) -> Void

    enum Animation { case new }

    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    private let removeHandler: RemoveHandler
    private let happening: Happening
    let id: UUID

    let time: String
    var animation: Animation?

    init(
        id: UUID,
        happening: Happening,
        animation: Animation? = nil,
        remove: @escaping RemoveHandler
    ) {
        self.id = id

        self.happening = happening
        self.time = Self.formatter.string(from: happening.dateCreated)
        self.animation = animation
        self.removeHandler = remove
    }

    func remove() { removeHandler(self, happening) }
    func removeAnimation() -> DayCellViewModel {
        DayCellViewModel(
            id: id,
            happening: happening,
            remove: removeHandler
        )
    }
}

extension DayCellViewModel: Equatable, Hashable {
    static func == (lhs: DayCellViewModel, rhs: DayCellViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
