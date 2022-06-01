//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

class ClockFace: UIView {
    var painter: ClockPainter?

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        if painter == nil {
            painter = ClockPainter()
        }

        painter?.draw(in: context, frame: rect)
    }
}
