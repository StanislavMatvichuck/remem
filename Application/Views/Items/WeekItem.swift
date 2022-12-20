//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

class WeekItem: UICollectionViewCell {
    static let reuseIdentifier = "WeekItem"
    static let spacing = UIHelper.spacing / 8
    static let sectionsAmount = 12 /// must define layout height

    // MARK: - Properties
    var viewModel: WeekItemViewModel! { didSet { configureContent() } }

    let day: UILabel
    let amount: UILabel
    let timesContainer: UIView
    let background: UIView
    let timingLabels: [UILabel]

    // MARK: - Init
    override init(frame: CGRect) {
        func makeAmountLabel() -> UILabel {
            let label = UILabel(al: true)
            label.textAlignment = .center
            label.numberOfLines = 1
            label.font = UIHelper.fontSmallBold
            label.textColor = UIHelper.itemFont
            label.text = " "
            return label
        }

        func makeTimeLabel() -> UILabel {
            let newLabel = UILabel(al: true)
            newLabel.text = " "
            newLabel.textAlignment = .center
            newLabel.font = UIHelper.font
            newLabel.textColor = UIHelper.background
            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.minimumScaleFactor = 0.1
            newLabel.numberOfLines = 1
            newLabel.layer.cornerRadius = UIHelper.radius
            newLabel.clipsToBounds = true
            newLabel.backgroundColor = .clear
            newLabel.transform = CGAffineTransform(scaleX: 1, y: -1)
            return newLabel
        }

        func makeTimingLabels() -> [UILabel] {
            var timings = [UILabel]()
            for _ in 1 ... Self.sectionsAmount { timings.append(makeTimeLabel()) }
            return timings
        }

        let timings = makeTimingLabels()

        func makeTimesContainer() -> UIView {
            let timingsStack = Self.makeVerticalStack(views: timings)
            timingsStack.transform = CGAffineTransform(scaleX: 1, y: -1)

            let view = UIView(al: true)
            view.addSubview(timingsStack)
            view.clipsToBounds = true

            NSLayoutConstraint.activate([
                timingsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                timingsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                timingsStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])

            return view
        }

        let timesContainer = makeTimesContainer()
        let day = makeAmountLabel()

        func makeBackground() -> UIView {
            let stack = Self.makeVerticalStack(views: [timesContainer, day])

            let background = UIView(al: true)
            background.addAndConstrain(stack, constant: Self.spacing)
            background.backgroundColor = UIHelper.itemBackground
            background.layer.cornerRadius = UIHelper.radius

            let view = UIView(al: true)
            view.addAndConstrain(background, constant: Self.spacing)
            return view
        }

        self.timingLabels = timings
        self.amount = makeAmountLabel()
        self.timesContainer = timesContainer
        self.day = day
        self.background = makeBackground()
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        amount.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        background.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        background.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        let content = Self.makeVerticalStack(views: [amount, background])
        contentView.addSubview(content)

        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIHelper.spacing / 2),
        ])
    }

    // MARK: - View lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        hideAll()
    }

    private func configureContent() {
        guard let viewModel = viewModel else { return }
        hideAll()

        day.text = viewModel.dayNumber
        day.textColor = viewModel.isToday ? UIHelper.brand : UIHelper.itemFont
        amount.text = viewModel.amount

        show(timings: viewModel.items)
    }
}

// MARK: - Private
extension WeekItem {
    private func show(timings: [String]) {
        for (index, timing) in timings.enumerated() {
            guard index < timingLabels.count else { break }
            timingLabels[index].backgroundColor = UIHelper.brandDimmed
            timingLabels[index].text = timing
        }
    }

    private func show(achievedGoalAmount: Int) {
        for (index, label) in timingLabels.enumerated() {
            label.backgroundColor = .systemGreen
            if index >= achievedGoalAmount { label.layer.opacity = 0.5 }
            if label.text == " " { label.layer.opacity = 0 }
        }
    }

    private func hideAll() {
        for label in timingLabels {
            label.layer.opacity = 1
            label.backgroundColor = .clear
            label.text = " "
        }
    }

    private static func makeVerticalStack(views: [UIView]) -> UIStackView {
        let stack = UIStackView(al: true)
        stack.spacing = Self.spacing
        stack.axis = .vertical
        for view in views { stack.addArrangedSubview(view) }
        return stack
    }
}
