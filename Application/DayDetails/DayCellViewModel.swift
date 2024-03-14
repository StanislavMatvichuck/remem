//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayCellViewModel: Identifiable {
    typealias RemoveHandler = () -> Void

    enum Animation { case new }

    private static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    let removeHandler: RemoveHandler
    private let happening: Happening
    let id: String

    let time: String
    var animation: Animation?

    init(
        id: String,
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
