//
//  WeekPageView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 21.12.2023.
//

import UIKit

final class WeekPageView: UICollectionViewCell {
    static let reuseIdentifier: String = "WeekPageView"
    static let daySpacing: CGFloat = .layoutSquare / 10

    let title: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontWeekTitle
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
        stack.spacing = WeekPageView.daySpacing
        return stack
    }()

    let daysBackground: UIStackView = {
        let stack = UIStackView(al: true)
        stack.distribution = .fillEqually
        stack.spacing = WeekPageView.daySpacing

        for _ in 0 ..< 7 {
            let dayBackground = UIView(al: true)
            dayBackground.backgroundColor = .border
            dayBackground.layer.cornerRadius = .layoutSquare / 10 * 1.6
            dayBackground.heightAnchor.constraint(equalTo: dayBackground.widthAnchor, multiplier: 4).isActive = true
            stack.addArrangedSubview(dayBackground)
        }

        return stack
    }()

    var viewModel: WeekPageViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    } }

    var service: ShowDayDetailsService?

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

        days.addSubview(daysBackground)

        NSLayoutConstraint.activate([
            days.widthAnchor.constraint(equalTo: daysBackground.widthAnchor),
            days.widthAnchor.constraint(equalTo: verticalStack.widthAnchor, constant: -2 * .buttonMargin),

            daysBackground.centerXAnchor.constraint(equalTo: days.centerXAnchor),
            daysBackground.topAnchor.constraint(equalTo: days.topAnchor),

            verticalStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            verticalStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            verticalStack.widthAnchor.constraint(equalTo: contentView.widthAnchor),
        ])

        configureDaysLayout()
    }

    private func configureDaysLayout() {
        for _ in 0 ..< WeekPageViewModel.daysCount {
            let day = WeekDayView()
            days.addArrangedSubview(day)
        }
    }

    private func configureAppearance() {
        month.textColor = .secondary
        title.textColor = .secondary
    }

    private func configureContent(_ viewModel: WeekPageViewModel) {
        title.text = viewModel.title
        month.text = viewModel.localisedMonth

        configureDaysContent(viewModel)
    }

    private func configureDaysContent(_ viewModel: WeekPageViewModel) {
        for index in 0 ..< WeekPageViewModel.daysCount {
            if let dayView = days.arrangedSubviews[index] as? WeekDayView {
                dayView.viewModel = viewModel.day(dayNumberInWeek: index)
                dayView.service = service
            }
        }
    }
}
