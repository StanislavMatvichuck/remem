//
//  ViewMainRow.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import IosUseCases
import UIKit

class EventCell: UITableViewCell {
    static let reuseIdentifier = "EventCell"
    static let backgroundDefault = UIHelper.background
    static let backgroundGoalReached = UIHelper.goalReachedBackground
    static let backgroundGoalNotReached = UIHelper.goalNotReachedBackground
    static let pinColor = UIHelper.brandDimmed
    static let height = .d2 + UIHelper.spacing

    // MARK: - Properties
    var viewModel: EventViewModel? { didSet { handleViewStateUpdate() } }
    var useCase: EventEditUseCasing?
    weak var coordinator: Coordinating?
    let swiper = Swiper()

    let viewRoot: UIView = {
        let view = UIView(al: true)
        view.layer.cornerRadius = .r2
        view.backgroundColor = EventCell.backgroundDefault
        return view
    }()

    let valueLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 3
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
        configureEventsHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        viewRoot.addSubview(swiper)
        viewRoot.addSubview(nameLabel)
        viewRoot.addSubview(valueLabel)
        contentView.addSubview(viewRoot)

        let height = contentView.heightAnchor.constraint(equalToConstant: Self.height)
        height.priority = .defaultLow /// tableView constraints fix

        NSLayoutConstraint.activate([
            height,
            nameLabel.centerXAnchor.constraint(equalTo: viewRoot.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: .d2),
            nameLabel.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, constant: -2 * .d2),

            valueLabel.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.r2),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),

            viewRoot.heightAnchor.constraint(equalToConstant: .d2),

            viewRoot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIHelper.spacingListHorizontal),
            viewRoot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIHelper.spacingListHorizontal),
            viewRoot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func configureEventsHandlers() {
        swiper.addTarget(self, action: #selector(handleSwipe), for: .primaryActionTriggered)
    }

    private func handleViewStateUpdate() {
        nameLabel.text = viewModel?.name
        valueLabel.text = viewModel?.amount

        if let vm = viewModel, vm.hasGoal {
            if vm.goalReached {
                viewRoot.backgroundColor = Self.backgroundGoalReached
            } else {
                viewRoot.backgroundColor = Self.backgroundGoalNotReached
            }
        } else {
            viewRoot.backgroundColor = Self.backgroundDefault
        }
    }

    // MARK: - View lifecycle
    override func prepareForReuse() {
        viewModel = nil
        useCase = nil
        super.prepareForReuse()
    }
}

// MARK: - User input
extension EventCell {
    @objc private func handleSwipe(_ swiper: Swiper) {
        guard let useCase, let viewModel else { return }
        useCase.addHappening(to: viewModel.event, date: .now)
    }

    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let viewModel else { return }
        coordinator?.showDetails(event: viewModel.event)
    }
}

// MARK: - Dark mode
extension EventCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        handleViewStateUpdate()
    }
}
