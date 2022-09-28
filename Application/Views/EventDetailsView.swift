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
        let label = UILabel(al: true)
        label.text = String(localizationId: "eventDetails.buttonGoalsInput")
        label.textAlignment = .center
        label.font = UIHelper.fontSmallBold
        label.textColor = UIHelper.brand

        let view = UIView(al: true)
        view.addAndConstrain(label, constant: UIHelper.spacing)
        view.backgroundColor = UIHelper.background
        return view
    }()

    let total: UILabel = makeAmountLabel()
    let dayAverage: UILabel = makeAmountLabel()

    private let viewModel: EventDetailsViewModeling

    // MARK: - Init
    init(viewModel: EventDetailsViewModeling) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
        configureContent()
    }

    private func configureLayout() {
        let bottomSpacing = UIView(al: true)

        let scroll = ViewScroll(.vertical)
        scroll.contain(views:
            week,
            goalsButton,
            clock,
            makeStatRow(labelAmount: total,
                        description: String(localizationId: "eventDetails.total")),
            makeStatRow(labelAmount: dayAverage,
                        description: String(localizationId: "eventDetails.dayAverage")),
            bottomSpacing)

        scroll.viewContent.setCustomSpacing(UIHelper.spacing, after: goalsButton)
        scroll.viewContent.setCustomSpacing(UIHelper.spacing, after: clock)

        addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomSpacing.heightAnchor.constraint(equalToConstant: UIHelper.spacingListHorizontal)
        ])
    }

    private func configureAppearance() {
        backgroundColor = .secondarySystemBackground
    }

    func configureContent() {
        total.text = viewModel.totalAmount
        dayAverage.text = viewModel.dayAverage
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
        view.spacing = UIHelper.spacing
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 0, left: UIHelper.spacing, bottom: 0, right: UIHelper.spacing)

        labelAmount.widthAnchor.constraint(equalToConstant: .wScreen / 4).isActive = true

        return view
    }

    private static func makeAmountLabel() -> UILabel {
        let labelAmount = UILabel(al: true)
        labelAmount.text = "\(0.0)"
        labelAmount.font = UIHelper.fontBold
        labelAmount.textColor = UIHelper.itemFont
        labelAmount.textAlignment = .right
        labelAmount.adjustsFontSizeToFitWidth = true
        labelAmount.minimumScaleFactor = 0.5
        return labelAmount
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
