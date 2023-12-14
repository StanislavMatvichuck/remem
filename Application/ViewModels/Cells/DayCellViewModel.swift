//
//  DayItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.12.2022.
//

import Domain
import Foundation

struct DayCellViewModel {
    static let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter
    }()

    typealias RemoveHandler = (Happening) -> Void

    let text: String
    let removeHandler: RemoveHandler

    private let happening: Happening

    init(happening: Happening, remove: @escaping RemoveHandler) {
        self.happening = happening
        self.text = Self.formatter.string(from: happening.dateCreated)
        self.removeHandler = remove
    }

    func remove() { removeHandler(happening) }
}


