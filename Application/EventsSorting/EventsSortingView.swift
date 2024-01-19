//
//  EventsSortingView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import UIKit

final class EventsSortingView: UIView {
    static let borderWidth : CGFloat = .buttonMargin
    let stack = {
        let view = UIStackView(al: true)
        view.axis = .vertical
        return view
    }()

    var viewModel: EventsSortingViewModel? {
        didSet {
            guard let viewModel else { return }
            configureContent(viewModel)
        }
    }

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        addAndConstrain(stack)
    }

    private func configureAppearance() {
        backgroundColor = .bg_item

        layer.borderWidth = Self.borderWidth
        layer.borderColor = UIColor.border.cgColor
        layer.cornerRadius = .layoutSquare / 4
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        clipsToBounds = true
    }

    private func configureContent(_ vm: EventsSortingViewModel) {
        for cell in stack.arrangedSubviews { cell.removeFromSuperview() }

        for index in 0 ..< vm.count {
            let cellView = EventsSortingCellView()
            cellView.viewModel = vm.cell(at: index)

            stack.addArrangedSubview(cellView)
        }

        let spacer = UIView(al: true)
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        stack.addArrangedSubview(spacer)
    }
}
