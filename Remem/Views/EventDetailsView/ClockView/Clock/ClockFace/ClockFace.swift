//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

class ClockFace: UIView {
    // MARK: - Init
    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        if layer.sublayers == nil {
            for index in 0 ... ClockSectionsList.size - 1 {
                let newSectionLayer = ClockSectionAnimatedLayer(frame: bounds)
                newSectionLayer.rotate(for: index)

                layer.addSublayer(newSectionLayer)
            }
        }
    }
}
