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
    let clock = UIView(al: true)

    let goalsButton: UIView = {
        let image = UIImage(systemName: "plus.circle")?
            .withTintColor(UIHelper.brand)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))
        let imageView = UIImageView(al: true)
        imageView.image = image

        let label = UILabel(al: true)
        label.text = "Add daily goal"
        label.font = UIHelper.fontSmallBold
        label.textColor = UIHelper.brand

        let buttonStack = UIStackView(al: true)
        buttonStack.axis = .horizontal
        buttonStack.alignment = .center

        buttonStack.backgroundColor = UIHelper.background
        buttonStack.layer.cornerRadius = 10

        buttonStack.addArrangedSubview(imageView)
        buttonStack.addArrangedSubview(label)

        buttonStack.spacing = UIHelper.spacing
        buttonStack.isLayoutMarginsRelativeArrangement = true
        buttonStack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: UIHelper.spacing,
                                                                       leading: UIHelper.spacing,
                                                                       bottom: UIHelper.spacing,
                                                                       trailing: UIHelper.spacing)

        let view = UIView(al: true)
        view.addAndConstrain(buttonStack, constant: UIHelper.spacing)

        return view
    }()

    let total: UILabel = makeAmountLabel()
    let thisWeekTotal: UILabel = makeAmountLabel()
    let lastWeekTotal: UILabel = makeAmountLabel()
    let dayAverage: UILabel = makeAmountLabel()
    let weekAverage: UILabel = makeAmountLabel()

    private let viewModel: EventDetailsViewModelInput

    // MARK: - Init
    init(viewModel: EventDetailsViewModelInput) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
        configureContent()
    }

    private func configureLayout() {
        let goalsButtonMargin = UIView(al: true)
        goalsButtonMargin.addSubview(goalsButton)

        NSLayoutConstraint.activate([
            goalsButton.leadingAnchor.constraint(equalTo: goalsButtonMargin.readableContentGuide.leadingAnchor),
            goalsButton.trailingAnchor.constraint(equalTo: goalsButtonMargin.readableContentGuide.trailingAnchor),

            goalsButton.topAnchor.constraint(equalTo: goalsButtonMargin.topAnchor),
            goalsButton.bottomAnchor.constraint(equalTo: goalsButtonMargin.bottomAnchor, constant: -UIHelper.spacing),
        ])

        let scroll = ViewScroll(.vertical)
        scroll.contain(views: week,
                       goalsButtonMargin,
                       make(title: "Hours distribution"),
                       clock,
                       make(title: "Stats"),
                       makeStatRow(labelAmount: total, description: "Total"),
                       makeStatRow(labelAmount: thisWeekTotal, description: "This week total"),
                       makeStatRow(labelAmount: lastWeekTotal, description: "Last week total"),
                       makeStatRow(labelAmount: dayAverage, description: "Day average"),
                       makeStatRow(labelAmount: weekAverage, description: "Week average"))

        addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func configureAppearance() {
        backgroundColor = .secondarySystemBackground
    }

    func configureContent() {
        total.text = viewModel.totalAmount
        thisWeekTotal.text = viewModel.thisWeekTotal
        lastWeekTotal.text = viewModel.lastWeekTotal
        dayAverage.text = viewModel.dayAverage
        weekAverage.text = viewModel.weekAverage
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

    private func makeStatRow(labelAmount: UILabel, description: String) -> UIView {
        let labelDescription = UILabel(al: true)
        labelDescription.text = description
        labelDescription.numberOfLines = 0
        labelDescription.font = UIHelper.font
        labelDescription.textColor = UIHelper.itemFont

        let view = UIStackView(al: true)
        view.axis = .horizontal
        view.addArrangedSubview(labelAmount)
        view.addArrangedSubview(labelDescription)

        return view
    }

    private static func makeAmountLabel() -> UILabel {
        let labelAmount = UILabel(al: true)
        labelAmount.text = "\(0.0)"
        labelAmount.font = UIHelper.fontBold
        labelAmount.textColor = UIHelper.itemFont
        return labelAmount
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
