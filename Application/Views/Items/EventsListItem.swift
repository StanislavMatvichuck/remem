//
//  ViewMainRow.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EventsListItem: UITableViewCell {
    static let reuseIdentifier = "EventCell"
    static let backgroundDefault = UIHelper.itemBackground
    static let backgroundGoalReached = UIHelper.goalReachedBackground
    static let backgroundGoalNotReached = UIHelper.goalNotReachedBackground
    static let pinColor = UIHelper.brandDimmed
    static let height = UIHelper.d2 + UIHelper.spacing

    // MARK: - Properties
    var viewModel: EventItemViewModel? { didSet { handleViewStateUpdate() } }
    let swiper = Swiper()

    let viewRoot: UIView = {
        let view = UIView(al: true)
        view.layer.cornerRadius = UIHelper.r2
        view.backgroundColor = EventsListItem.backgroundDefault
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
            nameLabel.heightAnchor.constraint(equalToConstant: UIHelper.d2),
            nameLabel.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, constant: -2 * UIHelper.d2),

            valueLabel.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -UIHelper.r2),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),

            viewRoot.heightAnchor.constraint(equalToConstant: UIHelper.d2),

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
        viewRoot.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleTap))
        )
    }

    private func handleViewStateUpdate() {
        nameLabel.text = viewModel?.name
        valueLabel.text = viewModel?.amount
    }

    // MARK: - View lifecycle
    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }
}

// MARK: - User input
extension EventsListItem {
    @objc private func handleSwipe(_ swiper: Swiper) {
        viewModel?.swipe()
    }

    @objc private func handleTap(_ gr: UITapGestureRecognizer) {
        viewModel?.select()
    }
}

// MARK: - Dark mode
extension EventsListItem {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        handleViewStateUpdate()
    }
}
