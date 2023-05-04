//
//  WeekView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

final class WeekView: UIView {
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
        field.attributedPlaceholder = WeekView.goalPlaceholder
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

    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.itemSize = WeekCell.layoutSize

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        view.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.reuseIdentifier)

        return view
    }()

    let weekdaysLine: UIStackView = {
        let view = UIStackView(frame: .zero)
        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false

        let formatter = DateFormatter()
        var days = formatter.veryShortWeekdaySymbols!

        days = Array(days[1..<days.count]) + days[0..<1]

        for (index, day) in days.enumerated() {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = day
            label.textAlignment = .center
            label.font = .fontSmallBold
            label.textColor = UIColor.secondary

            view.addArrangedSubview(label)

            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: .layoutSquare),
                label.heightAnchor.constraint(equalTo: label.widthAnchor),
            ])
        }

        return view
    }()

    private var scrollHappened = false

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        configureLayout()
        configureGoalToolbar()
        clipsToBounds = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func draw(_ rect: CGRect) {
        accessory.leftDistance = summary.superview!.convert(summary.center, to: self).x
    }

    // MARK: - Public behaviour

    func configure(_ vm: WeekViewModel) {
        collection.reloadData()
        configureSummary(vm)
    }

    func configureSummary(_ vm: WeekViewModel) {
        let index = weekIndexForCurrentScrollPosition()
        guard let page = vm.pages[index] else { return }
        summary.text = page.sum
        configureGoalDescription(page)
        resizeGoalInputAndRedrawAccessory()
    }

    func moveSelectionToEnd() {
        DispatchQueue.main.async {
            self.goal.selectedTextRange = self.goal.textRange(
                from: self.goal.endOfDocument,
                to: self.goal.endOfDocument
            )
        }
    }

    func resizeGoalInputAndRedrawAccessory() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.goal.invalidateIntrinsicContentSize()
            self.redrawAccessory()
        }
    }

    func installPlaceholder() {
        guard goal.text == "" else { return }
        goal.attributedPlaceholder = WeekView.goalPlaceholder
    }

    func removePlaceholder() {
        goal.placeholder = nil
    }

    func scrollToCurrentWeek(_ vm: WeekViewModel) {
        guard !scrollHappened else { return }
        setInitialScrollPosition(vm)
        scrollHappened = true
    }

    // MARK: - Private

    private func weekIndexForCurrentScrollPosition() -> Int {
        let collectionWidth = collection.bounds.width
        let offset = collection.contentOffset.x
        guard offset != 0 else { return 0 }
        return Int(offset / collectionWidth)
    }

    private func setInitialScrollPosition(_ vm: WeekViewModel) {
        collection.layoutIfNeeded()
        collection.scrollToItem(
            at: IndexPath(row: vm.scrollToIndex, section: 0),
            at: .left,
            animated: false
        )

        configureSummary(vm)
    }

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
        stack.addArrangedSubview(collection)
        stack.addArrangedSubview(weekdaysLine)

        stack.setCustomSpacing(.buttonMargin, after: accessory)

        addSubview(progressShade)
        addAndConstrain(stack)

        NSLayoutConstraint.activate([
            horizontalStack.heightAnchor.constraint(equalToConstant: .layoutSquare * 1.5 - .buttonMargin),

            accessory.widthAnchor.constraint(equalTo: widthAnchor),
            accessory.heightAnchor.constraint(equalToConstant: .layoutSquare / 2),

            collection.heightAnchor.constraint(equalToConstant: WeekCell.layoutSize.height),
            collection.widthAnchor.constraint(equalToConstant: .layoutSquare * 7),

            progressShade.heightAnchor.constraint(equalToConstant: .layoutSquare * 7),
            progressShade.widthAnchor.constraint(equalToConstant: .layoutSquare * 7),
            progressShade.trailingAnchor.constraint(equalTo: leadingAnchor),
            progressShade.bottomAnchor.constraint(equalTo: accessory.bottomAnchor),
        ])
    }

    private func configureGoalToolbar() {
        let view = GoalInputAccessoryView()
        view.done.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handleDone)
        ))
        goal.inputAccessoryView = view
    }

    @objc private func handleDone() { endEditing(true) }

    private func redrawAccessory() {
        setNeedsDisplay()
        accessory.setNeedsDisplay()
    }

    private func configureGoalDescription(_ page: WeekViewModelPage) {
        if page.goal == nil, page.goalEditable == false {
            configureSummaryWithoutGoal()
        } else {
            configureSummaryWithGoal(page)
        }
    }

    private func configureSummaryWithoutGoal() {
        progress.isHidden = true
        goal.isHidden = true
        of.isHidden = true
        configureProgressShade(0)
    }

    private func configureSummaryWithGoal(_ page: WeekViewModelPage) {
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

    private func configureEditableGoal(_ page: WeekViewModelPage) {
        if page.goal == nil {
            installPlaceholder()
            configureProgressShade(0)
        } else {
            removePlaceholder()
            configureProgressShade(page.progress)
        }
    }

    private func configurePastGoal(_ page: WeekViewModelPage) {
        goalAccessory.isHidden = true
        goal.isUserInteractionEnabled = false
    }

    private func configureProgressShade(_ progress: CGFloat) {
        let maxTransition = 7 * CGFloat.layoutSquare
        let xTranslation = (maxTransition * progress).clamped(to: 0 ... maxTransition)

        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.progressShade.transform = CGAffineTransform(translationX: xTranslation, y: 0)
        }

        animator.startAnimation()
    }
}
