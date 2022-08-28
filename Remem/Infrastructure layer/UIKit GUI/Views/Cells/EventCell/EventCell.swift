//
//  ViewMainRow.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

final class EventCell: UITableViewCell {
    static let reuseIdentifier = "EventCell"
    static let backgroundColor = UIHelper.background
    static let pinColor = UIHelper.brandDimmed
    static let height = .d2 + UIHelper.spacing

    // MARK: - Properties
    var viewModel: EventCellVMInput! { didSet { update() } }

    var animator = EventCellAnimator()

    var movableCenterXSuccessPosition: CGFloat { viewRoot.bounds.width - .r2 }
    var movableCenterXInitialPosition: CGFloat { .r2 }
    var movableCenterXPosition: CGFloat {
        get { viewMovable.layer.position.x }
        set { viewMovable.layer.position.x = newValue }
    }

    let viewRoot: UIView = {
        let view = UIView(al: true)
        view.layer.cornerRadius = .r2
        view.backgroundColor = EventCell.backgroundColor
        return view
    }()

    let viewMovable: UIView = {
        let view = UIView(al: true)
        view.layer.cornerRadius = .r1
        view.backgroundColor = EventCell.pinColor
        return view
    }()

    let valueLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        return label
    }()

    // Private
    private let nameLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupViewRoot()
        setupViewMovable()
        setupEventHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupViewRoot() {
        viewRoot.addSubview(nameLabel)
        viewRoot.addSubview(valueLabel)

        contentView.addSubview(viewRoot)

        let height = contentView.heightAnchor.constraint(equalToConstant: Self.height)
        height.priority = .defaultLow /// tableView constraints fix

        NSLayoutConstraint.activate([
            height,
            nameLabel.centerXAnchor.constraint(equalTo: viewRoot.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: .d2),
            nameLabel.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, constant: -2 * .d2),

            valueLabel.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.r2),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),

            viewRoot.heightAnchor.constraint(equalToConstant: .d2),

            viewRoot.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIHelper.spacingListHorizontal),
            viewRoot.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIHelper.spacingListHorizontal),
            viewRoot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func setupViewMovable() {
        viewRoot.addSubview(viewMovable)

        NSLayoutConstraint.activate([
            viewMovable.widthAnchor.constraint(equalToConstant: .d1),
            viewMovable.heightAnchor.constraint(equalToConstant: .d1),

            viewMovable.centerXAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .r2),
            viewMovable.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movableCenterXPosition = movableCenterXInitialPosition
        animator.animateIfNeeded(cell: self)
        viewModel = nil
    }
}

// MARK: - User input
extension EventCell {
    private func setupEventHandlers() {
        viewMovable.addGestureRecognizer(UIPanGestureRecognizer(
            target: self, action: #selector(handlePan)))
        viewRoot.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handlePress)))
    }

    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        viewModel.select()
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let movedView = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: contentView)
        let newXPosition = (movedView.center.x + translation.x * 2)
            .clamped(to: movableCenterXInitialPosition ... movableCenterXSuccessPosition)
        let newCenter = CGPoint(x: newXPosition, y: movedView.center.y)

        if gestureRecognizer.state == .began {
            UIDevice.vibrate(.light)
        } else if gestureRecognizer.state == .changed {
            movedView.center = newCenter
            gestureRecognizer.setTranslation(CGPoint.zero, in: contentView)
        } else if
            gestureRecognizer.state == .ended ||
            gestureRecognizer.state == .cancelled
        {
            if movableCenterXPosition >= movableCenterXSuccessPosition {
                viewModel.swipe()
                animator.scheduleAnimation()
            } else {
                animator.handleUnfinishedSwipe(cell: self)
            }
        }
    }
}

extension EventCell: EventCellVMOutput {
    func update() {
        guard viewModel != nil else { return }
        nameLabel.text = viewModel.name
        valueLabel.text = viewModel.amount
    }
}

// MARK: - Dark mode
extension EventCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewMovable.layer.backgroundColor = Self.pinColor.cgColor
        viewRoot.layer.backgroundColor = Self.backgroundColor.cgColor
    }
}
