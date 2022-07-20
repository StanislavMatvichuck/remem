//
//  ClockViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.07.2022.
//

import UIKit

class ClockViewModel {
    typealias View = ClockView
    typealias Model = ClockSectionsList

    // MARK: - Properties
    private var model: Model
    private var view: View?

    // MARK: - Init
    init(model: Model) { self.model = model }
}

// MARK: - Public
extension ClockViewModel {
    func configure(_ view: View) {
        self.view = view

        for i in 0 ... ClockSectionsList.size - 1 {
            guard
                let layers = view.clock.clockFace.layer.sublayers as? [ClockSectionAnimatedLayer],
                let section = model.section(at: i)
            else { continue }

            layers[i].animate(at: i, to: section)
        }
    }
}
