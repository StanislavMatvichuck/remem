//
//  DayOfWeekView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class DayOfWeekView: UIView, LoadableView, UsingLoadableViewModel {
    var viewModel: Loadable<DayOfWeekViewModel>? { didSet {
        if viewModel?.loading == true {
            displayLoading()
        } else {
            disableLoadingCover()
        }

        guard let viewModel = viewModel?.vm else { return }
        configureContent(viewModel)
    } }

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - Private
    private let stack: UIStackView = {
        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .trailing
        stack.spacing = WeekPageView.daySpacing
        return stack
    }()

    private func configureLayout() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        addSubview(stack)
        stack.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .buttonMargin).isActive = true
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func configureAppearance() {}
    private func configureContent(_ vm: DayOfWeekViewModel) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 0 ..< vm.count {
            let cell = DayOfWeekCellView()
            cell.viewModel = vm.cell(at: index)
            stack.addArrangedSubview(cell)
        }
    }
}
