//
//  TemporaryItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import AudioToolbox
import UIKit

final class EventCell: UITableViewCell, EventsListCell {
    static let reuseIdentifier = "TemporaryItem"

    let view = EventCellView()
    let swipeAnimator: AnimatingSwipe = DefaultSwipeAnimator()
    var cellAnimator: AnimatingHappeningCreation?
    var viewModel: EventCellViewModel? { didSet {
        guard let viewModel else { return }
        view.configure(viewModel)

        /// Animation starts here because this class knows the difference
        if let oldValue {
            if viewModel.isValueIncreased(oldValue) {
                cellAnimator?.animate(self)
            }

            if viewModel.isProgressIncreased(oldValue) {
                cellAnimator?.animateProgress(self)
            }
        }
    }}

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        contentView.addAndConstrain(view)
        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: .layoutSquare * 2)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }

    private func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
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

    private func vibrateOnSwipe() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator.prepare()
        impactFeedbackGenerator.impactOccurred()
    }

    // MARK: - Events handling
    @objc private func handleTap() { viewModel?.tapHandler() }
    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        guard let view = pan.view else { return }
        let translation = max(0, pan.translation(in: view).x)
        let progress = abs(translation * 5 / contentView.bounds.width)

        switch pan.state {
        case .began:
            let distance = contentView.bounds.width - self.view.circleContainer.circle.bounds.width - 4 * .buttonMargin
            let scale = .buttonRadius / (CGFloat.buttonRadius - .buttonMargin)
            swipeAnimator.start(
                animated: self.view.circleContainer.circle,
                forXDistance: distance,
                andScaleFactor: scale
            )

            vibrateOnSwipe()

        case .changed:
            swipeAnimator.set(progress: progress)
        default:
            if progress >= 1.0 {
                swipeAnimator.animateSuccess { [weak self] in
                    self?.viewModel?.swipeHandler()
                }
            } else {
                swipeAnimator.returnToStart(from: progress) { [weak self] in
                    self?.vibrateOnSwipe()
                }
            }
        }
    }
}

extension EventCell: TrailingSwipeActionsConfigurationProviding {
    func trailingActionsConfiguration() -> UISwipeActionsConfiguration {
        guard let viewModel else { fatalError("can't create configuration without viewModel") }

        let renameAction = UIContextualAction(
            style: .normal,
            title: viewModel.rename,
            handler: { _, _, completion in
                self.viewModel?.renameActionHandler(viewModel)
                completion(true)
            }
        )

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: viewModel.delete,
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
