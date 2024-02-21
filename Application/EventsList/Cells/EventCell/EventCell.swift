//
//  TemporaryItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import UIKit

final class EventCell: UICollectionViewCell {
    static let reuseIdentifier = "EventCell"

    let view = EventCellView()
    let staticBackgroundView = UIView(al: true)

    var viewModel: EventCellViewModel? { didSet {
        guard let viewModel else { return }
        view.configure(viewModel)
        playAnimationIfNeeded(oldValue)
    }}

    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = Self.reuseIdentifier
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
        viewModel = nil
    }

    // MARK: - Private
    private func configureLayout() {
        contentView.addSubview(staticBackgroundView)
        contentView.addAndConstrain(view)

        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: .layoutSquare * 2)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            heightConstraint,
            staticBackgroundView.widthAnchor.constraint(equalTo: view.stack.widthAnchor),
            staticBackgroundView.heightAnchor.constraint(equalTo: view.stack.heightAnchor),
            staticBackgroundView.centerXAnchor.constraint(equalTo: view.stack.centerXAnchor),
            staticBackgroundView.centerYAnchor.constraint(equalTo: view.stack.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        backgroundColor = .bg
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
extension EventCell {
    func playAnimationIfNeeded(_ oldValue: EventCellViewModel?) {
        /// exists after controller.viewModel.didSet
        /// does not exist after cell reusing (during scroll and first render)
        guard oldValue != nil else { return }
        switch viewModel?.animation {
        case .swipe:
            view.circleContainer.prepareForHappeningCreationAnimation()
            SwiperAnimationsHelper.animateHappening(view)
        case .aboveSwipe: SwiperAnimationsHelper.animate(neighbour: view, isAbove: true)
        case .belowSwipe: SwiperAnimationsHelper.animate(neighbour: view, isAbove: false)
        default: return
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
