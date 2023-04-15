//
//  EventItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

final class EventItem: UITableViewCell, EventsListCell {
    static var reuseIdentifier = "EventItem"

    let swiper = Swiper()

    final class RootView: UIView, UsingSwipingHintDisplaying {}
    let viewRoot: RootView = {
        let view = RootView(al: true)
        view.layer.cornerRadius = .buttonRadius
        view.backgroundColor = .background_secondary
        return view
    }()

    let valueLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .fontSmallBold
        label.textColor = UIColor.text_primary
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .font
        label.textColor = UIColor.text_primary
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.numberOfLines = 3
        return label
    }()

    var viewModel: EventItemViewModel? {
        didSet { handleViewStateUpdate(oldValue) }
    }

    var valueBackgroundCircle: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = UIColor.background
        let radius = CGFloat.swiperRadius
        view.layer.cornerRadius = radius

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 2 * radius),
            view.heightAnchor.constraint(equalToConstant: 2 * radius),
        ])

        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessibilityIdentifier = "EventItem"
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        viewModel = nil
        viewRoot.swipingHint?.removeFromSuperview()
        swiper.resetToInitialStateWithoutAnimation()
        super.prepareForReuse()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        handleViewStateUpdate()
    }

    private func configureLayout() {
        viewRoot.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: viewRoot.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: .buttonHeight),
            nameLabel.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, constant: -2 * .buttonRadius),
        ])

        viewRoot.addSubview(valueBackgroundCircle)
        NSLayoutConstraint.activate([
            valueBackgroundCircle.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.buttonRadius),
            valueBackgroundCircle.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
        ])

        viewRoot.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.buttonRadius),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
        ])

        viewRoot.addSubview(swiper)
        contentView.addSubview(viewRoot)

        let height = contentView.heightAnchor.constraint(equalToConstant: 2 * .layoutSquare)
        height.priority = .defaultLow /// tableView constraints fix

        NSLayoutConstraint.activate([
            height,
            viewRoot.heightAnchor.constraint(equalToConstant: .buttonHeight),
            viewRoot.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * .buttonMargin),
            viewRoot.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            viewRoot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    private func configureEventHandlers() {
        swiper.addTarget(self, action: #selector(handleSwipe), for: .primaryActionTriggered)
        viewRoot.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleTap))
        )
    }

    private func handleViewStateUpdate(_ oldValue: EventItemViewModel? = nil) {
        nameLabel.text = viewModel?.name
        valueLabel.text = viewModel?.amount

        if let viewModel, viewModel.hintEnabled {
            viewRoot.addSwipingHint()
        } else {
            viewRoot.removeSwipingHint()
        }

        animateFromSuccessIfNeeded(oldValue)
    }

    private func animateFromSuccessIfNeeded(_ oldValue: EventItemViewModel?) {
        if
            let viewModel, let oldValue,
            let oldAmount = Int(oldValue.amount),
            let newAmount = Int(viewModel.amount),
            oldAmount < newAmount
        {
            swiper.animateFromSuccess()
        }
    }

    @objc private func handleSwipe(_ swiper: Swiper) {
        viewModel?.swipe()
    }

    @objc private func handleTap(_ gr: UITapGestureRecognizer) {
        viewRoot.animateTapReceiving {
            self.viewModel?.select()
        }
    }
}

extension EventItem: TrailingSwipeActionsConfigurationProviding {
    func trailingActionsConfiguration() -> UISwipeActionsConfiguration {
        guard let viewModel else { fatalError("can't create configuration without viewModel") }

        let renameAction = UIContextualAction(
            style: .normal,
            title: viewModel.rename,
            handler: { _, _, completion in
                self.viewModel?.initiateRenaming()
                completion(true)
            }
        )

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: viewModel.delete,
            handler: { _, _, completion in
                self.viewModel?.remove()
                completion(true)
            }
        )

        return UISwipeActionsConfiguration(
            actions: [renameAction, deleteAction]
        )
    }
}
