//
//  NewWeekPageView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 21.12.2023.
//

import UIKit

final class NewWeekPageView: UICollectionViewCell {
    static let reuseIdentifier: String = "NewWeekPageView"
    static let daySpacing: CGFloat = .layoutSquare / 5

    let title: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontClock
        label.textAlignment = .center

        return label
    }()

    let month: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        label.textAlignment = .center

        return label
    }()

    let days: UIStackView = {
        let stack = UIStackView(al: true)
        stack.distribution = .fillEqually
        stack.spacing = NewWeekPageView.daySpacing
        return stack
    }()

    var viewModel: NewWeekPageViewModel? {
        didSet {
            guard let viewModel else { return }
            configureContent(viewModel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        let verticalStack = UIStackView(al: true)
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.spacing = Self.daySpacing

        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(days)
        verticalStack.addArrangedSubview(month)

        contentView.addSubview(verticalStack)

        days.widthAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 1, constant: Self.daySpacing * -2).isActive = true
        verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        verticalStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        verticalStack.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
    }

    private func configureAppearance() {
        month.textColor = .secondary
        title.textColor = .secondary
    }

    private func configureContent(_ viewModel: NewWeekPageViewModel) {
        title.text = viewModel.title
        month.text = viewModel.localisedMonth
        for day in days.arrangedSubviews { day.removeFromSuperview() }

        for index in 0 ..< NewWeekPageViewModel.daysCount {
            let day = NewWeekDayView()
            day.viewModel = viewModel.day(for: index)
            days.addArrangedSubview(day)
        }
    }
}
