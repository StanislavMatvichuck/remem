//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

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
            for index in 0 ..< viewModel.size {
                layer.addSublayer(makeAnimatedLayer(for: index))
            }
        }
    }

    private func makeAnimatedLayer(for index: Int) -> ClockItem {
        ClockItem(
            section: viewModel.sections[index],
            frame: bounds,
            size: viewModel.size
        )
    }
}
