//
//  TemporaryItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import UIKit

final class EventCell: UITableViewCell {
    static let reuseIdentifier = "EventCell"

    let view = EventCellView()
    let staticBackgroundView = UIView(al: true)

    var viewModel: EventCellViewModel? { didSet {
        guard let viewModel else { return }
        view.configure(viewModel)
        playAnimation(viewModel.animation)
    }}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessibilityIdentifier = Self.reuseIdentifier
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        removeSwipingHint()
        view.animatedProgress.prepareForReuse()
        viewModel = nil
    }

    // MARK: - Private
    private func configureLayout() {
        contentView.addSubview(staticBackgroundView)
        contentView.addAndConstrain(view)

        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: .layoutSquare * 2)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true

        staticBackgroundView.widthAnchor.constraint(equalTo: view.stack.widthAnchor).isActive = true
        staticBackgroundView.heightAnchor.constraint(equalTo: view.stack.heightAnchor).isActive = true
        staticBackgroundView.centerXAnchor.constraint(equalTo: view.stack.centerXAnchor).isActive = true
        staticBackgroundView.centerYAnchor.constraint(equalTo: view.stack.centerYAnchor).isActive = true
    }

    private func configureAppearance() {
        backgroundColor = .bg
        selectionStyle = .none
        staticBackgroundView.backgroundColor = .border
        staticBackgroundView.layer.cornerRadius = view.stack.layer.cornerRadius
    }

    // MARK: - Events handling
    private func configureEventHandlers() {
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))

        view.circleContainer.addTarget(
            self, action: #selector(handleSwipe),
            for: .valueChanged
        )
    }

    @objc private func handleSwipe() { viewModel?.swipeHandler() }
    @objc private func handleTap() { viewModel?.tapHandler() }
}

// MARK: - Happening creation animations
private extension EventCell {
    func playAnimation(_ animation: EventCellViewModel.Animations) {
        switch animation {
        case .swipe: SwiperAnimationsHelper.animateHappening(view)
        case .aboveSwipe: SwiperAnimationsHelper.animate(neighbour: view, isAbove: true)
        case .belowSwipe: SwiperAnimationsHelper.animate(neighbour: view, isAbove: false)
        case .none: return
        }
    }

    func animateGoalProgress() {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: SwiperAnimationsHelper.progressMovementDuration,
            delay: 0,
            animations: {
                self.view.animatedProgress.move()
                self.view.layoutIfNeeded()
            }
        )
    }
}
