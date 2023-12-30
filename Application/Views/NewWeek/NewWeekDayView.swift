//
//  NewWeekDayView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.12.2023.
//

import UIKit

final class NewWeekDayView: UIStackView {
    private let roundContainer: UIStackView = {
        let roundView = UIStackView(al: true)
        roundView.axis = .vertical
        roundView.alignment = .fill
        return roundView
    }()

    private let happenings = NewWeekDayHappeningView()
    private let dayNumber = NewWeekDayNumberView()
    private let dayName: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        label.textAlignment = .center
        return label
    }()

    var viewModel: NewWeekDayViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureAppearance() {
        dayName.textColor = .secondary
        roundContainer.layer.cornerRadius = NewWeekPageView.daySpacing / 2
        roundContainer.clipsToBounds = true
        roundContainer.backgroundColor = .bg_item
    }

    private func configureContent(_ viewModel: NewWeekDayViewModel) {
        dayName.text = viewModel.dayName

        dayNumber.configureContent(viewModel)
        happenings.configureContent(viewModel)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        roundContainer.addGestureRecognizer(tapRecognizer)
    }

    @objc private func handleTap() {
        guard let daysContainer = superview,
              let weekContainer = daysContainer.superview
        else { return }

        viewModel?.tapHandler(
            DayDetailsAnimationsHelper.makeCellPresentationSliding(
                animatedView: self,
                heightTo: weekContainer.frame.maxY
            ),
            DayDetailsAnimationsHelper.makeCellDismissal(
                animatedView: self,
                heightTo: 0
            )
        )
    }

    private func configureLayout() {
        axis = .vertical

        roundContainer.addArrangedSubview(happenings)
        roundContainer.addArrangedSubview(dayNumber)

        addArrangedSubview(roundContainer)
        addArrangedSubview(dayName)
        dayName.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        setCustomSpacing(NewWeekPageView.daySpacing, after: roundContainer)
    }
}
