//
//  GoalsInputViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import UIKit

class GoalsInputViewModel: NSObject {
    typealias View = GoalsInputView
    typealias Model = Event

    // MARK: - Properties

    private let model: Model
    private weak var view: View?

    // MARK: - Init
    init(model: Model) {
        self.model = model
    }
}

// MARK: - Public
extension GoalsInputViewModel {
    func configure(_ view: View) {
        self.view = view
    }
}

// MARK: - Private
extension GoalsInputViewModel {}
