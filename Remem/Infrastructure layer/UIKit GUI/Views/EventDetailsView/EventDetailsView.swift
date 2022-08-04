//
//  ViewHappeningsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EventDetailsView: UIView {
    // MARK: - Properties
    let week = UIView(al: true)
    let happeningsList = UIView(al: true)
    let clock = UIView(al: true)

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        let statsView = makeStatsView()
        let scroll = ViewScroll(.vertical)
        scroll.contain(views:
            week,
            make(title: "Hours distribution"),
            clock,
            make(title: "Stats"),
            statsView)

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
    private func makeStatsView() -> UIView {
        let statRow01 = makeStatsRow(amounts: [1.0, 23.4], descriptions: ["Some text", "Another label"])
        let statRow02 = makeStatsRow(amounts: [45.6, 789.0], descriptions: ["Some text", "Another much longer label"])
        let statsView = UIView(al: true)
        statsView.addSubview(statRow01)
        statsView.addSubview(statRow02)

        NSLayoutConstraint.activate([
            statRow01.topAnchor.constraint(equalTo: statsView.topAnchor),
            statRow01.leadingAnchor.constraint(equalTo: statsView.readableContentGuide.leadingAnchor),
            statRow01.trailingAnchor.constraint(equalTo: statsView.readableContentGuide.trailingAnchor),

            statRow02.topAnchor.constraint(equalTo: statRow01.bottomAnchor, constant: UIHelper.spacing),
            statRow02.leadingAnchor.constraint(equalTo: statsView.readableContentGuide.leadingAnchor),
            statRow02.trailingAnchor.constraint(equalTo: statsView.readableContentGuide.trailingAnchor),
            statRow02.bottomAnchor.constraint(equalTo: statsView.bottomAnchor, constant: -UIHelper.spacing),
        ])

        return statsView
    }

    private func makeStatsRow(amounts: [Double], descriptions: [String]) -> UIStackView {
        let stack = UIStackView(al: true)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .firstBaseline
        stack.spacing = UIHelper.spacing

        for (index, amount) in amounts.enumerated() {
            stack.addArrangedSubview(makeStatTile(amount: amount, description: descriptions[index]))
        }

        return stack
    }

    private func makeStatTile(amount: Double, description: String) -> UIView {
        let labelAmount = UILabel(al: true)
        labelAmount.text = "\(amount)"
        labelAmount.font = UIHelper.fontBold
        labelAmount.textColor = UIHelper.itemFont

        let labelDescription = UILabel(al: true)
        labelDescription.text = description
        labelDescription.numberOfLines = 0
        labelDescription.font = UIHelper.font
        labelDescription.textColor = UIHelper.itemFont

        let view = UIStackView(al: true)
        view.axis = .vertical
        view.addArrangedSubview(labelAmount)
        view.addArrangedSubview(labelDescription)

        return view
    }
}
