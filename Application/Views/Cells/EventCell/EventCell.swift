//
//  TemporaryItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import AudioToolbox
import UIKit

final class EventCell: UITableViewCell, EventsListCell {
    static let reuseIdentifier = "EventCell"

    let view = EventCellView()
    let staticBackgroundView = UIView(al: true)
    let swipeAnimator: AnimatingSwipe = DefaultSwipeAnimator()
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
        swipeAnimator.prepareForReuse()
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
        backgroundColor = .clear
        selectionStyle = .none
        staticBackgroundView.backgroundColor = .border
        staticBackgroundView.layer.cornerRadius = view.stack.layer.cornerRadius
    }

    private func configureEventHandlers() {
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))

        view.circleContainer.circle.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan)
        ))
    }

    private func playAnimation(_ animation: EventCellViewModel.Animations) {
        switch animation {
        case .swipe:
            animateHappeningCreation()
        case .aboveSwipe:
            animateNeighborHappeningCreationReactionAbove()
        case .belowSwipe:
            animateNeighborHappeningCreationReactionBelow()
        case .none:
            return
        }
    }

    // MARK: - Events handling
    @objc private func handleTap() { viewModel?.tapHandler() }
    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        guard let view = pan.view else { return }
        let translation = max(0, pan.translation(in: view).x)
        let progress = abs(translation * 5 / contentView.bounds.width)
        let progressSufficient = progress >= 1.0

        switch pan.state {
        case .began:
            let distance = contentView.bounds.width - self.view.circleContainer.circle.bounds.width - 4 * .buttonMargin
            let scale = .buttonRadius / (CGFloat.buttonRadius - .buttonMargin)
            swipeAnimator.start(
                animated: self.view.circleContainer.circle,
                forXDistance: distance,
                andScaleFactor: scale
            )

        case .changed:
            swipeAnimator.set(progress: progress)
        default:
            if progressSufficient {
                swipeAnimator.animateSuccess { [weak self] in self?.viewModel?.swipeHandler() }
            } else {
                swipeAnimator.returnToStart(from: progress) {}
            }
        }
    }
}

extension EventCell: TrailingSwipeActionsConfigurationProviding {
    func trailingActionsConfiguration() -> UISwipeActionsConfiguration {
        guard let viewModel else { fatalError("can't create configuration without viewModel") }

        let renameAction = UIContextualAction(
            style: .normal,
            title: EventCellViewModel.rename,
            handler: { _, _, completion in
                self.viewModel?.renameActionHandler(viewModel)
                completion(true)
            }
        )

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: EventCellViewModel.delete,
            handler: { _, _, completion in
                self.viewModel?.deleteActionHandler()
                completion(true)
            }
        )

        return UISwipeActionsConfiguration(
            actions: [renameAction, deleteAction]
        )
    }
}

// MARK: - Happening creation animations
extension EventCell {
    func animateHappeningCreation() {
        let animator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeOut
        )

        let view = self.view

        animator.addAnimations {
            view.transform = CGAffineTransform(
                translationX: .buttonHeight,
                y: 0
            )
        }

        animator.addCompletion { _ in
            let returnAnimator = UIViewPropertyAnimator(
                duration: SwiperAnimationsHelper.forwardDuration,
                curve: .easeIn
            )

            let circleSnapshot = view.circleContainer.circle.snapshotView(afterScreenUpdates: false)

            if let circleSnapshot {
                circleSnapshot.alpha = 0
                circleSnapshot.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(circleSnapshot)
                NSLayoutConstraint.activate([
                    circleSnapshot.widthAnchor.constraint(equalToConstant: (.buttonRadius - .buttonMargin) * 2),
                    circleSnapshot.heightAnchor.constraint(equalToConstant: (.buttonRadius - .buttonMargin) * 2),
                    circleSnapshot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    circleSnapshot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .buttonMargin * 2),
                ])
            }

            returnAnimator.addAnimations {
                view.transform = .identity
                circleSnapshot?.alpha = 1
            }

            view.circleContainer.circle.alpha = 0

            returnAnimator.addCompletion { _ in
                self.swipeAnimator.prepareForReuse()
                view.circleContainer.circle.alpha = 1
                circleSnapshot?.removeFromSuperview()
            }

            returnAnimator.startAnimation()
        }

        animator.startAnimation()
    }

    func animateNeighborHappeningCreationReactionAbove() {
        let animator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeOut
        ) {
            let angle = CGFloat.pi / 180 * 3
            self.view.transform = CGAffineTransform(
                rotationAngle: -angle
            )
        }

        animator.addCompletion { _ in
            UIViewPropertyAnimator(
                duration: SwiperAnimationsHelper.forwardDuration,
                curve: .easeOut
            ) {
                self.view.transform = .identity
            }.startAnimation()
        }

        animator.startAnimation()
    }

    func animateNeighborHappeningCreationReactionBelow() {
        let animator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeOut
        ) {
            let angle = CGFloat.pi / 180 * 3
            self.view.transform = CGAffineTransform(
                rotationAngle: angle
            )
        }

        animator.addCompletion { _ in
            UIViewPropertyAnimator(
                duration: SwiperAnimationsHelper.forwardDuration,
                curve: .easeOut
            ) {
                self.view.transform = .identity
            }.startAnimation()
        }

        animator.startAnimation()
    }
}

// MARK: - Goal progress animation
extension EventCell {
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
