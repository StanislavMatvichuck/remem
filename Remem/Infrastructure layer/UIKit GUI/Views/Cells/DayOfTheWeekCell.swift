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
    weak var delegate: WeekCellDelegate?

    var day: UILabel = WeekCell.makeLabel()
    var amount: UILabel = WeekCell.makeLabel()

    lazy var happeningsContainer: UIView = {
        let timings: [UIView] = (0 ... Self.sectionsAmount - 1).map { index in
            Self.makeLabel(for: index)
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
        let stack = makeVerticalStack(views: happeningsContainer, day)

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
        delegate = nil
        hideAll()
        super.prepareForReuse()
    }
}

// MARK: - Public
extension WeekCell {
    func showSections(amount: Int, happenings: [Happening]) {
        hideAll()
        showGoal(amount: amount)
        showHappenings(happenings: happenings)
    }
}

// MARK: - Events handling
extension WeekCell {
    @objc private func handlePress() {
        UIDevice.vibrate(.medium)
        animate()
        delegate?.didPress(cell: self)
    }
}

// MARK: - Private
extension WeekCell {
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

    private static func makeLabel() -> UILabel {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIHelper.fontSmallBold
        label.textColor = UIHelper.itemFont
        label.text = " "
        return label
    }

    private static func makeLabel(for index: Int) -> UILabel {
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

    private func animate() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.9
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.07
        animation.autoreverses = true
        animation.repeatCount = 1
        contentView.layer.add(animation, forKey: nil)
    }

    private func makeVerticalStack(views: UIView...) -> UIStackView { makeVerticalStack(views: views) }
    private func makeVerticalStack(views: [UIView]) -> UIStackView {
        let stack = UIStackView(al: true)
        stack.spacing = Self.spacing
        stack.axis = .vertical
        for view in views { stack.addArrangedSubview(view) }
        return stack
    }

    private func hideAll() {
        guard let labels = happeningsContainer.subviews[0].subviews as? [UILabel] else { return }
        labels.forEach { label in
            label.backgroundColor = .clear
            label.text = " "
        }
    }

    private func showGoal(amount: Int) {
        guard let labels = happeningsContainer.subviews[0].subviews as? [UILabel] else { return }
        for i in 0 ... amount - 1 {
            labels[i].backgroundColor = UIHelper.itemBackground
        }
    }

    private func showHappenings(happenings: [Happening]) {
        guard let labels = happeningsContainer.subviews[0].subviews as? [UILabel] else { return }

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short

        for (index, happening) in happenings.enumerated() {
            labels[index].backgroundColor = UIHelper.brandDimmed
            labels[index].text = formatter.string(from: happening.dateCreated)
        }
    }
}
