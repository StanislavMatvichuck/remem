//
//  HourDistributionView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class HourDistributionView: UIView, LoadableView, UsingLoadableViewModel {
    var viewModel: Loadable<HourDistributionViewModel>? { didSet {
        if viewModel?.loading == true {
            displayLoading()
        } else {
            disableLoadingCover()
        }

        guard let viewModel = viewModel?.vm else { return }
        configureContent(viewModel)
    }}

    private let stack: UIStackView = {
        let view = UIStackView(al: true)
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = 2.0
        return view
    }()

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - Private
    private func configureLayout() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        addSubview(stack)
        stack.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .buttonMargin).isActive = true
        stack.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func configureAppearance() {}
    private func configureContent(_ vm: HourDistributionViewModel) {
        stack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for index in 0 ..< vm.count {
            let cell = HourDistributionCellView()
            cell.viewModel = vm.cell(at: index)
            stack.addArrangedSubview(cell)
        }
    }
}
