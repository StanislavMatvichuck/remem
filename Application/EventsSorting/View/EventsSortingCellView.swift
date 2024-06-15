//
//  EventsSortingCellView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.01.2024.
//

import UIKit

final class EventsSortingCellView: UIView {
    let title: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = UITestID.orderingVariant.rawValue
        return label
    }()

    var viewModel: EventsSortingCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}
    
    var setEventsOrderingService: SetEventsOrderingService?

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - Private
    private func configureLayout() {
        heightAnchor.constraint(equalToConstant: .buttonHeight).isActive = true
        let horizontalMargin = CGFloat.buttonMargin + EventsSortingView.borderWidth
        addAndConstrain(title, left: horizontalMargin, right: horizontalMargin)
    }

    private func configureAppearance() {
        backgroundColor = .clear
        title.textColor = .remem_text
    }

    private func configureContent(_ vm: EventsSortingCellViewModel) {
        title.text = vm.title
    }

    private func configureEventHandlers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        guard let service = setEventsOrderingService, let viewModel else { return }
        service.serve(SetEventsOrderingServiceArgument(
            eventsIdentifiersOrder: nil,
            ordering: viewModel.sorter
        ))
    }
}
