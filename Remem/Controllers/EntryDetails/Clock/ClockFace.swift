//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

class ClockFace: UIView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
