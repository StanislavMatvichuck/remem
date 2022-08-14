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

    var isEnabled = false { didSet { configureVisibility() }}
    var isSubmitEnabled = false { didSet { configureSubmit() }}

    // MARK: - Init
    init(model: Model) {
        self.model = model
        // update isEnabled
    }
}

// MARK: - Public
extension GoalsInputViewModel {
    func configure(_ view: View) {
        self.view = view
        configureVisibility()
        configureSubmit()
    }
}

// MARK: - Private
extension GoalsInputViewModel {
    private func configureVisibility() {
        if isEnabled {
            view?.picker.isHidden = false
            view?.submit.isHidden = false
        } else {
            view?.picker.isHidden = true
            view?.submit.isHidden = true
        }
    }

    private func configureSubmit() {
        if isSubmitEnabled {
            view?.submit.backgroundColor = UIHelper.brand
            if let label = view?.submit.subviews[0] as? UILabel {
                label.textColor = UIHelper.background
            }
        } else {
            view?.submit.backgroundColor = UIHelper.background
            if let label = view?.submit.subviews[0] as? UILabel {
                label.textColor = UIHelper.itemFont
            }
        }
    }
}
