//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

// bullshit class. what is its responsibility?
class ClockFace: UIView {
    let viewModel: ClockViewModel

    init(viewModel: ClockViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        installAnimatedSublayers()
    }
}

// MARK: - Private
extension ClockFace {
    private func installAnimatedSublayers() {
        if layer.sublayers == nil {
            for index in 0 ... ClockViewModel.size - 1 {
                let newSectionLayer = makeAnimatedLayer(for: index)
                layer.addSublayer(newSectionLayer)
            }
        }
    }

    private func makeAnimatedLayer(for index: Int) -> ClockSectionAnimatedLayer {
        let layer = ClockSectionAnimatedLayer(
            section: viewModel.section(at: index)!,
            frame: bounds
        )
        layer.rotate(for: index)
        return layer
    }
}
