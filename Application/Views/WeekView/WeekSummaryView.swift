//
//  NewWeekGoalView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.05.2023.
//

import UIKit

final class WeekSummaryView: UIView {
    /// Main digits
    let amount: UITextField = {
        let label = UITextField(al: true)
        label.font = .fontBoldBig
        label.isEnabled = false
        return label
    }()

    let goal: UITextField = {
        let field = UITextField(al: true)
        field.font = .fontBoldBig
        field.keyboardType = .numberPad
        field.textAlignment = .center
        field.returnKeyType = .done
        field.borderStyle = .none
        field.tintColor = .secondary
        field.accessibilityIdentifier = UITestAccessibilityIdentifier.textFieldGoal.rawValue
        return field
    }()

    let progress: UITextField = {
        let label = UITextField(al: true)
        label.font = .fontBoldBig
        label.isEnabled = false
        return label
    }()

    /// Digits containers
    let amountBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    let goalBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    let progressBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    /// Additional views
    let title: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontSmallBold
        label.numberOfLines = 1
        return label
    }()

    let goalAccessory: UIView = {
        let view = UIView(al: true)
        return view
    }()

    let animatedProgressIndicator: UIView = {
        let view = UIView(al: true)
        return view
    }()

    let amountSubtitle: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontWeeklyGoalSubtitle
        label.text = WeekSummaryViewModel.amountSubtitle
        label.numberOfLines = 1
        return label
    }()

    let goalSubtitle: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontWeeklyGoalSubtitle
        label.text = WeekSummaryViewModel.goalSubtitle
        label.numberOfLines = 1
        return label
    }()

    let progressSubtitle: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontWeeklyGoalSubtitle
        label.text = WeekSummaryViewModel.progressSubtitle
        label.numberOfLines = 1
        return label
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        configureGoalToolbar()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public
    func configure(_ vm: WeekSummaryViewModel) {
        title.text = vm.title
        amount.text = vm.amount

        if vm.goal == "0" {
            goal.text = ""
            installPlaceholder()
        } else {
            goal.text = vm.goal
            removePlaceholder()
        }

        goal.isEnabled = vm.goalTappable
        progress.text = vm.progress
        goalBackground.isHidden = vm.goalHidden
        progressBackground.isHidden = vm.progressHidden
        goalAccessory.isHidden = vm.goalTappable
        goalBackground.backgroundColor = vm.goalTappable ? .bg_primary : .bg_secondary
        progress.textColor = vm.goalAchieved ? .text_goalAchieved : .secondary
        configureProgressShade(vm.progressValue)
    }

    func installPlaceholder() {
        guard goal.text == "" else { return }
        let string = WeekSummaryViewModel.goalPlaceholder
        let attributes = [
            NSAttributedString.Key.font: UIFont.fontBold,
            NSAttributedString.Key.foregroundColor: UIColor.bg_item,
        ]
        goal.attributedPlaceholder = NSAttributedString(string: string, attributes: attributes)
        goalSubtitle.text = " "
    }

    func removePlaceholder() {
        goal.placeholder = nil
        goalSubtitle.text = WeekSummaryViewModel.goalSubtitle
    }

    func moveSelectionToEnd() {
        DispatchQueue.main.async {
            let field = self.goal
            field.selectedTextRange = field.textRange(
                from: field.endOfDocument,
                to: field.endOfDocument
            )
        }
    }

    var animatedTopConstraint: NSLayoutConstraint!

    // MARK: - Private
    private func configureLayout() {
        let margin = CGFloat.buttonMargin * 1.2
        let smallerMargin = CGFloat.buttonMargin / 2

        animatedTopConstraint = animatedProgressIndicator.heightAnchor.constraint(equalTo: progressBackground.heightAnchor, multiplier: 0)
        progressBackground.addSubview(animatedProgressIndicator)

        let amountStack = UIStackView(al: true)
        amountStack.axis = .vertical
        amountStack.alignment = .center
        amountStack.addArrangedSubview(amount)
        amountStack.addArrangedSubview(amountSubtitle)

        let goalStack = UIStackView(al: true)
        goalStack.axis = .vertical
        goalStack.alignment = .center
        goalStack.addArrangedSubview(goal)
        goalStack.addArrangedSubview(goalSubtitle)

        let progressStack = UIStackView(al: true)
        progressStack.axis = .vertical
        progressStack.alignment = .center
        progressStack.addArrangedSubview(progress)
        progressStack.addArrangedSubview(progressSubtitle)

        goal.setContentHuggingPriority(.defaultLow, for: .vertical)
        goal.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        amountBackground.addAndConstrain(amountStack, top: smallerMargin, left: margin, right: margin)
        goalBackground.addAndConstrain(goalStack, top: smallerMargin, left: margin, right: margin)
        progressBackground.addAndConstrain(progressStack, top: smallerMargin, left: margin, right: margin)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: .layoutSquare * 2),

            animatedTopConstraint,
            animatedProgressIndicator.widthAnchor.constraint(equalTo: progressBackground.widthAnchor),
            animatedProgressIndicator.centerXAnchor.constraint(equalTo: progressBackground.centerXAnchor),
            animatedProgressIndicator.bottomAnchor.constraint(equalTo: progressBackground.bottomAnchor),
        ])

        let stack = UIStackView(al: true)
        stack.addArrangedSubview(amountBackground)
        stack.addArrangedSubview(goalBackground)
        stack.addArrangedSubview(progressBackground)
        stack.alignment = .bottom
        stack.layer.cornerRadius = .buttonMargin
        stack.clipsToBounds = true

        let verticalStack = UIStackView(al: true)
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(stack)

        addAndConstrain(verticalStack, bottom: .buttonMargin)
    }

    private func configureAppearance() {
        title.textColor = .secondary
        amount.textColor = .text
        goal.textColor = .bg_item
        progress.textColor = .secondary
        amountBackground.backgroundColor = .bg_item
        goalBackground.backgroundColor = .bg_primary
        progressBackground.backgroundColor = .bg_item
        animatedProgressIndicator.backgroundColor = .bg_secondary
        amountSubtitle.textColor = .secondary
        goalSubtitle.textColor = .bg_item
        progressSubtitle.textColor = .bg_item
    }

    private func configureGoalToolbar() {
        let view = GoalInputAccessoryView()
        view.done.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handleDone)
        ))
        goal.inputAccessoryView = view
    }

    @objc private func handleDone() { endEditing(true) }

    private func configureProgressShade(_ progress: CGFloat) {
        animatedTopConstraint.isActive = false
        animatedTopConstraint = nil

        animatedTopConstraint = animatedProgressIndicator.heightAnchor.constraint(equalTo: progressBackground.heightAnchor, multiplier: progress.clamped(to: 0 ... 1))
        animatedTopConstraint.isActive = true

        let backgroundColor = progress >= 1 ? UIColor.bg_goal_achieved : UIColor.bg_goal
        animatedProgressIndicator.backgroundColor = backgroundColor
    }
}
