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
        /// this gives me an old value for cell view model
        /// allows to apply swipe animation but not above swipe or below swipe
        guard let viewModel else { return }
        view.configure(viewModel)
        playAnimationIfNeeded(oldValue)
    }}

    var tapService: ShowEventDetailsService?
    var swipeService: CreateHappeningService?
    var removeService: RemoveEventService?

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
        tapService = nil
        swipeService = nil
        removeService = nil
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

    @objc private func handleSwipe() {
        guard let viewModel, let swipeService else { return }
        swipeService.serve(CreateHappeningServiceArgument(date: .now))
    }

    @objc private func handleTap() {
        view.animateTapReceiving {
            guard let tapService = self.tapService else { return }
            tapService.serve(ApplicationServiceEmptyArgument())
        }
    }
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

    func playSwipeAnimation() {
        view.circleContainer.prepareForHappeningCreationAnimation()
        SwiperAnimationsHelper.animateHappening(view)
    }
}
