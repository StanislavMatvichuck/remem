//
//  EventsSortingView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.01.2024.
//

import UIKit

protocol EventsSortingCellViewFactoring {
    func makeEventsSortingCellView() -> EventsSortingCellView
}

final class EventsSortingView: UIView {
    static let borderWidth: CGFloat = 1

    let stack = {
        let view = UIStackView(al: true)
        view.axis = .vertical
        return view
    }()

    var viewModel: EventsSortingViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    } }

    var cells: [EventsSortingCellView]?
    private let service: SetEventsOrderingService

    init(service: SetEventsOrderingService) {
        self.service = service
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    func animateSelectionBackground(to: Int, completion: (() -> Void)? = nil) {
        let a = UIViewPropertyAnimator(
            duration: EventsSortingAnimationsHelper.duration,
            curve: .easeInOut,
            animations: {
                self.constraint.constant = CGFloat(to) * .buttonHeight
                self.layoutIfNeeded()
            }
        )
        a.addCompletion { _ in completion?() }
        a.startAnimation()
    }

    // MARK: - Private
    private lazy var constraint: NSLayoutConstraint = {
        selectionBackground.topAnchor.constraint(equalTo: topAnchor)
    }()

    private let selectionBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    private func configureLayout() {
        addSubview(selectionBackground)
        selectionBackground.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        selectionBackground.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        selectionBackground.heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        constraint.isActive = true
        addAndConstrain(stack)
    }

    private func configureAppearance() {
        backgroundColor = .bg_item
        selectionBackground.backgroundColor = .bg_secondary

        layer.borderWidth = Self.borderWidth
        layer.borderColor = UIColor.border.cgColor
        layer.cornerRadius = .layoutSquare / 4
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        clipsToBounds = true
    }

    private func configureContent(_ vm: EventsSortingViewModel) {
        installCellsIfNeeded(vm)

        for index in 0 ..< vm.count {
            cells?[index].viewModel = vm.cell(at: index)
            cells?[index].setEventsOrderingService = service
        }

        if let from = vm.animateFrom {
            animateSelectionBackground(to: from.rawValue)
        } else {
            animateSelectionBackground(to: vm.activeSorterIndex)
        }
    }

    private func installCellsIfNeeded(_ vm: EventsSortingViewModel) {
        if cells == nil {
            var cells = [EventsSortingCellView]()

            for cell in stack.arrangedSubviews { cell.removeFromSuperview() }

            for _ in 0 ..< vm.count {
                let cellView = EventsSortingCellView()
                cells.append(cellView)
                stack.addArrangedSubview(cellView)
            }

            self.cells = cells

            let spacer = UIView(al: true)
            spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
            stack.addArrangedSubview(spacer)
        }
    }
}
