//
//  WeekGoalView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 08.05.2023.
//

import UIKit

final class WeekGoalView: UIView {
    static let goalPlaceholder: NSAttributedString = {
        NSAttributedString(
            string: "your weekly goal",
            attributes: [
                NSAttributedString.Key.font: UIFont.font,
                NSAttributedString.Key.foregroundColor: UIColor.secondary,
            ]
        )
    }()

    let summary: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontBoldBig
        label.textColor = UIColor.text_primary
        label.text = "0"
        label.numberOfLines = 1
        return label
    }()

    let goal: UITextField = {
        let field = UITextField(al: true)
        field.font = .fontBoldBig
        field.textColor = UIColor.text_primary
        field.keyboardType = .numberPad
        field.attributedPlaceholder = WeekGoalView.goalPlaceholder
        field.textAlignment = .center
        field.returnKeyType = .done
        return field
    }()

    let goalAccessory: UIView = {
        let accessory = UIView(al: true)
        accessory.backgroundColor = .primary
        accessory.layer.cornerRadius = .buttonMargin / 4
        return accessory
    }()

    let progress: UILabel = {
        let label = UILabel(al: true)
        label.font = .fontBoldBig
        label.textColor = UIColor.secondary
        label.text = "= 67%"
        label.numberOfLines = 1
        return label
    }()

    let progressShade: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = .secondary_dimmed
        view.layer.opacity = 0.4
        return view
    }()

    let of: UILabel = {
        let of = UILabel(al: true)
        of.font = .font
        of.text = "of"
        of.textColor = .secondary
        return of
    }()

    let accessory = WeekAccessoryView()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func draw(_ rect: CGRect) {
        accessory.leftDistance = summary.superview!.convert(summary.center, to: self).x
    }

    // MARK: - Public
    func moveSelectionToEnd() {
        DispatchQueue.main.async {
            self.goal.selectedTextRange = self.goal.textRange(
                from: self.goal.endOfDocument,
                to: self.goal.endOfDocument
            )
        }
    }

    func installPlaceholder() {
        guard goal.text == "" else { return }
        goal.attributedPlaceholder = WeekGoalView.goalPlaceholder
    }

    func removePlaceholder() {
        goal.placeholder = nil
    }

    func configureGoalDescription(_ page: EventWeeklyGoalViewModel) {
        if page.goal == nil, page.goalEditable == false {
            configureSummaryWithoutGoal()
        } else {
            configureSummaryWithGoal(page)
        }
    }

    func redrawAccessory() {
        setNeedsDisplay()
        accessory.setNeedsDisplay()
    }

    // MARK: - Private
    private func configureLayout() {
        goal.addSubview(goalAccessory)
        NSLayoutConstraint.activate([
            goalAccessory.widthAnchor.constraint(equalTo: goal.widthAnchor),
            goalAccessory.heightAnchor.constraint(equalToConstant: .buttonMargin / 2),
            goalAccessory.centerXAnchor.constraint(equalTo: goal.centerXAnchor),
            goalAccessory.centerYAnchor.constraint(equalTo: goal.bottomAnchor),
        ])

        let horizontalStack = UIStackView(al: true)
        horizontalStack.axis = .horizontal

        horizontalStack.addArrangedSubview(summary)
        horizontalStack.addArrangedSubview(of)
        horizontalStack.addArrangedSubview(goal)
        horizontalStack.addArrangedSubview(progress)

        horizontalStack.setCustomSpacing(.buttonMargin, after: summary)
        horizontalStack.setCustomSpacing(.buttonMargin, after: of)
        horizontalStack.setCustomSpacing(.buttonMargin, after: goal)

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.alignment = .center
        stack.addArrangedSubview(horizontalStack)
        stack.addArrangedSubview(accessory)

        stack.setCustomSpacing(.buttonMargin, after: accessory)

        addSubview(progressShade)
        addAndConstrain(stack)

        NSLayoutConstraint.activate([
            horizontalStack.heightAnchor.constraint(equalToConstant: .layoutSquare * 1.5 - .buttonMargin),

            accessory.widthAnchor.constraint(equalTo: widthAnchor),
            accessory.heightAnchor.constraint(equalToConstant: .layoutSquare / 2),

            progressShade.heightAnchor.constraint(equalToConstant: .layoutSquare * 7),
            progressShade.widthAnchor.constraint(equalToConstant: .layoutSquare * 7),
            progressShade.trailingAnchor.constraint(equalTo: leadingAnchor),
            progressShade.bottomAnchor.constraint(equalTo: accessory.bottomAnchor),
        ])
    }

    private func configureSummaryWithoutGoal() {
        progress.isHidden = true
        goal.isHidden = true
        of.isHidden = true
        configureProgressShade(0)
    }

    private func configureSummaryWithGoal(_ page: EventWeeklyGoalViewModel) {
        progress.isHidden = false
        goal.isHidden = false
        of.isHidden = false

        progress.text = page.percentage
        goal.text = page.goal

        if page.goalEditable {
            configureEditableGoal(page)
        } else {
            configurePastGoal(page)
        }
    }

    private func configureEditableGoal(_ page: EventWeeklyGoalViewModel) {
        if page.goal == nil {
            installPlaceholder()
            configureProgressShade(0)
        } else {
            removePlaceholder()
            configureProgressShade(page.progress)
        }

        goalAccessory.isHidden = false
        goal.isUserInteractionEnabled = true
    }

    private func configurePastGoal(_ page: EventWeeklyGoalViewModel) {
        goalAccessory.isHidden = true
        goal.isUserInteractionEnabled = false
    }

    private func configureProgressShade(_ progress: CGFloat) {
        let maxTransition = 7 * CGFloat.layoutSquare
        let xTranslation = (maxTransition * progress).clamped(to: 0 ... maxTransition)
        // TODO: use EventWeeklyGoalViewModel.state here
        let backgroundColor = progress >= 1 ? UIColor.goal_achieved : UIColor.secondary_dimmed

        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.progressShade.transform = CGAffineTransform(translationX: xTranslation, y: 0)
            self.progressShade.backgroundColor = backgroundColor
        }

        animator.startAnimation()
    }
}
