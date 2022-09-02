//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

protocol WeekCellDelegate: AnyObject {
    func didPress(cell: WeekCell)
}

class WeekCell: UICollectionViewCell {
    static let reuseIdentifier = "CellDay"
    static let spacing = UIHelper.spacing / 8
    static let sectionsAmount = 12 /// must define layout height

    enum Kind {
        case past
        case created
        case data
        case today
        case future
    }

    // MARK: - Properties
    var viewModel: WeekCellViewModelInput! { didSet { configureContent() }}

    var day: UILabel = WeekCell.makeAmountLabel()
    var amount: UILabel = WeekCell.makeAmountLabel()

    lazy var timesContainer: UIView = {
        let timings: [UIView] = (0 ... Self.sectionsAmount - 1).map { index in
            Self.makeTimeLabel(for: index)
        }

        let timingsStack = makeVerticalStack(views: timings)
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
    }()

    lazy var background: UIView = {
        let stack = makeVerticalStack(views: timesContainer, day)

        let background = UIView(al: true)
        background.addAndConstrain(stack, constant: Self.spacing)
        background.backgroundColor = UIHelper.background
        background.layer.cornerRadius = UIHelper.radius

        let view = UIView(al: true)
        view.addAndConstrain(background, constant: Self.spacing)
        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePress)))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        hideAll()
    }

    func configureContent() {
        guard let viewModel = viewModel else { return }
        day.text = viewModel.dayNumber
        day.textColor = viewModel.isToday ? UIHelper.brand : UIHelper.itemFont
        amount.text = viewModel.amount

        showGoal(amount: viewModel.goalsAmount)
        show(timings: viewModel.happeningsTimings)

        if viewModel.isAchieved { show(achievedGoalAmount: viewModel.goalsAmount) }
    }
}

// MARK: - Public
extension WeekCell {
    func showGoal(amount: Int) {
        for (index, label) in timingsLabels.enumerated() {
            guard index < amount else { break }
            label.backgroundColor = UIHelper.itemBackground
        }
    }

    func show(timings: [String]) {
        for (index, timing) in timings.enumerated() {
            guard index < timingsLabels.count else { break }
            timingsLabels[index].backgroundColor = UIHelper.brandDimmed
            timingsLabels[index].text = timing
        }
    }

    func show(achievedGoalAmount: Int) {
        for (index, label) in timingsLabels.enumerated() {
            label.backgroundColor = .systemGreen
            if index >= achievedGoalAmount { label.layer.opacity = 0.5 }
            if label.text == " " { label.layer.opacity = 0 }
        }
    }

    func hideAll() {
        for label in timingsLabels {
            label.layer.opacity = 1
            label.backgroundColor = .clear
            label.text = " "
        }
    }
}

// MARK: - Events handling
extension WeekCell {
    @objc private func handlePress() {
        UIDevice.vibrate(.medium)
        animate()
        viewModel.select()
    }
}

// MARK: - WeekCellViewModelOutput
extension WeekCell: WeekCellViewModelOutput {
    func update() {
        configureContent()
    }
}

// MARK: - Private
extension WeekCell {
    private var timingsLabels: [UILabel] {
        timesContainer.subviews[0].subviews as! [UILabel]
    }

    private func configureLayout() {
        amount.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        background.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        background.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        let content = makeVerticalStack(views: amount, background)
        contentView.addSubview(content)
        NSLayoutConstraint.activate([
            content.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            content.topAnchor.constraint(equalTo: contentView.topAnchor),
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIHelper.spacing / 2),
        ])
    }

    private static func makeAmountLabel() -> UILabel {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIHelper.fontSmallBold
        label.textColor = UIHelper.itemFont
        label.text = " "
        return label
    }

    private static func makeTimeLabel(for index: Int) -> UILabel {
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

    private func makeVerticalStack(views: UIView...) -> UIStackView { makeVerticalStack(views: views) }
    private func makeVerticalStack(views: [UIView]) -> UIStackView {
        let stack = UIStackView(al: true)
        stack.spacing = Self.spacing
        stack.axis = .vertical
        for view in views { stack.addArrangedSubview(view) }
        return stack
    }
}
