//
//  ViewHappeningsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EventDetailsView: UIView {
    enum EventStat: CaseIterable {
        case total
        case average
        case weekTotal
        case weekAverage

				// TODO: localization
        func localizedDescription() -> String {
            switch self {
            case .total: return "Total"
            case .average: return "Average"
            case .weekTotal: return "Week total"
            case .weekAverage: return "Week average"
            }
        }
    }

    // MARK: - Properties
    let week = UIView(al: true)
    let clock = UIView(al: true)

    lazy var statsView: UIView = {
        let view = UIStackView(al: true)
        view.axis = .vertical

        for stat in EventStat.allCases {
            let statView = makeStatTile(stat: stat)
            view.addArrangedSubview(statView)
        }

        return view
    }()

    var statsLabels = [EventStat: UILabel]()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        let statsMarginContainer = UIView(al: true)
        statsMarginContainer.addSubview(statsView)

        NSLayoutConstraint.activate([
            statsView.leadingAnchor.constraint(equalTo: statsMarginContainer.readableContentGuide.leadingAnchor),
            statsView.trailingAnchor.constraint(equalTo: statsMarginContainer.readableContentGuide.trailingAnchor),

            statsView.topAnchor.constraint(equalTo: statsMarginContainer.topAnchor),
            statsView.bottomAnchor.constraint(equalTo: statsMarginContainer.bottomAnchor, constant: -UIHelper.spacing),
        ])

        let scroll = ViewScroll(.vertical)
        scroll.contain(views:
            week,
            make(title: "Hours distribution"),
            clock,
            make(title: "Stats"),
            statsMarginContainer)

        addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func make(title: String) -> UIView {
        let label = UILabel(al: true)
        label.text = title
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont

        let view = UIView(al: true)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        return view
    }
}

// MARK: - Private
extension EventDetailsView {
    private func makeStatTile(stat: EventStat) -> UIView {
        let labelAmount = UILabel(al: true)
        labelAmount.text = "\(0.0)"
        labelAmount.font = UIHelper.fontBold
        labelAmount.textColor = UIHelper.itemFont

        let labelDescription = UILabel(al: true)
        labelDescription.text = stat.localizedDescription()
        labelDescription.numberOfLines = 0
        labelDescription.font = UIHelper.font
        labelDescription.textColor = UIHelper.itemFont

        let view = UIStackView(al: true)
        view.axis = .vertical
        view.addArrangedSubview(labelAmount)
        view.addArrangedSubview(labelDescription)

        statsLabels[stat] = labelAmount

        return view
    }
}
