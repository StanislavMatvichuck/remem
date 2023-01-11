//
//  EventItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

class EventItem: UITableViewCell {
    let swiper = Swiper()

    let viewRoot: UIView = {
        let view = UIView(al: true)
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
        super.prepareForReuse()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        handleViewStateUpdate()
    }

    private func configureLayout() {
        viewRoot.addSubview(swiper)
        viewRoot.addSubview(nameLabel)
        viewRoot.addSubview(valueLabel)
        contentView.addSubview(viewRoot)

        let height = contentView.heightAnchor.constraint(equalToConstant: UIHelper.height)
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

    private func configureEventHandlers() {
        swiper.addTarget(self, action: #selector(handleSwipe), for: .primaryActionTriggered)
        viewRoot.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleTap))
        )
    }

    private func handleViewStateUpdate() {
        nameLabel.text = viewModel?.name
        valueLabel.text = viewModel?.amount
    }

    @objc private func handleSwipe(_ swiper: Swiper) {
        viewModel?.swipe()
    }

    @objc private func handleTap(_ gr: UITapGestureRecognizer) {
        viewModel?.select()
    }
}
