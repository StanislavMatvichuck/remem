//
//  ClockView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class ClockView: UIView {
    // MARK: - Properties
    let clock = Clock()
    let animator = ClockAnimator()

    // MARK: - Init
    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        addAndConstrain(clock)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
