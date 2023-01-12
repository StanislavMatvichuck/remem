//
//  EventItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

class EventItem: UITableViewCell {
    let swiper = Swiper()

    final class RootView: UIView, UsingSwipingHintDisplaying {}
    let viewRoot: RootView = {
        let view = RootView(al: true)
        view.layer.cornerRadius = UIHelper.r2
        view.backgroundColor = UIHelper.itemBackground
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

    var viewModel: EventItemViewModel? {
        didSet {
            handleViewStateUpdate()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        viewModel = nil
        viewRoot.swipingHint?.removeFromSuperview()
        super.prepareForReuse()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        handleViewStateUpdate()
    }

    private func configureLayout() {
        viewRoot.addSubview(swiper)

        viewRoot.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: viewRoot.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: UIHelper.d2),
            nameLabel.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, constant: -2 * UIHelper.d2),
        ])

        viewRoot.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -UIHelper.r2),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
        ])

        contentView.addSubview(viewRoot)

        let height = contentView.heightAnchor.constraint(equalToConstant: UIHelper.height)
        height.priority = .defaultLow /// tableView constraints fix

        NSLayoutConstraint.activate([
            height,
            viewRoot.heightAnchor.constraint(equalToConstant: UIHelper.d2),
            viewRoot.widthAnchor.constraint(equalTo: contentView.widthAnchor),
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

    private func handleViewStateUpdate() {
        nameLabel.text = viewModel?.name
        valueLabel.text = viewModel?.amount

        if let viewModel, viewModel.hintEnabled {
            viewRoot.addSwipingHint()
        } else {
            viewRoot.swipingHint?.removeFromSuperview()
        }
    }

    @objc private func handleSwipe(_ swiper: Swiper) {
        viewModel?.swipe()
    }

    @objc private func handleTap(_ gr: UITapGestureRecognizer) {
        viewModel?.select()
    }
}
