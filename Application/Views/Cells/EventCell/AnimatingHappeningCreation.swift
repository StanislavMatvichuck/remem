//
//  AnimatingTemporaryItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.04.2023.
//

import UIKit

protocol AnimatingHappeningCreation {
    func animate(_: EventCell)
    func animateProgress(_: EventCell)
}

final class DefaultHappeningCreationAnimator: AnimatingHappeningCreation {
    enum NeighbourPosition: Int {
        case above = -1
        case below = 1
    }

    private let table: UITableView

    init(table: UITableView) {
        self.table = table
    }

    func animate(_ item: EventCell) {
        animateHappeningCreation(item)

        guard let index = table.indexPath(for: item) else { return }
        let prevIndex = IndexPath(row: index.row - 1, section: index.section)
        let nextIndex = IndexPath(row: index.row + 1, section: index.section)

        if let neighbour = table.cellForRow(at: prevIndex) as? EventCell { animate(neighbour.view, .above) }
        if let neighbour = table.cellForRow(at: nextIndex) as? EventCell { animate(neighbour.view, .below) }
    }

    func animateProgress(_ cell: EventCell) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: SwiperAnimationsHelper.progressMovementDuration,
            delay: 0,
            animations: {
                cell.view.moveProgress()
                cell.view.layoutIfNeeded()
            }
        )
    }

    private func animateHappeningCreation(_ item: EventCell) {
        let animator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeOut
        )

        animator.addAnimations {
            item.view.transform = CGAffineTransform(
                translationX: .buttonMargin,
                y: 0
            )
        }

        animator.addCompletion { _ in
            let returnAnimator = UIViewPropertyAnimator(
                duration: SwiperAnimationsHelper.forwardDuration,
                curve: .easeIn
            )

            let circleSnapshot = item.view.circle.snapshotView(afterScreenUpdates: false)

            if let circleSnapshot {
                circleSnapshot.alpha = 0
                circleSnapshot.translatesAutoresizingMaskIntoConstraints = false
                item.view.addSubview(circleSnapshot)
                NSLayoutConstraint.activate([
                    circleSnapshot.widthAnchor.constraint(equalToConstant: (.buttonRadius - .buttonMargin) * 2),
                    circleSnapshot.heightAnchor.constraint(equalToConstant: (.buttonRadius - .buttonMargin) * 2),
                    circleSnapshot.centerYAnchor.constraint(equalTo: item.view.centerYAnchor),
                    circleSnapshot.leadingAnchor.constraint(equalTo: item.view.leadingAnchor, constant: .buttonMargin * 2),
                ])
            }

            returnAnimator.addAnimations {
                item.view.transform = .identity
                item.view.circle.alpha = 0
                circleSnapshot?.alpha = 1
            }

            returnAnimator.addCompletion { _ in
                item.swipeAnimator.prepareForReuse()
                item.view.circle.alpha = 1
                circleSnapshot?.removeFromSuperview()
            }

            returnAnimator.startAnimation()
        }

        animator.startAnimation()
    }

    private func animate(_ neighbour: UIView, _ position: NeighbourPosition) {
        let animator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeOut
        ) {
            let angle = CGFloat.pi / 180
            neighbour.transform = CGAffineTransform(
                rotationAngle: position == .above ? -angle : angle
            )
        }

        animator.addCompletion { _ in
            UIViewPropertyAnimator(
                duration: SwiperAnimationsHelper.forwardDuration,
                curve: .easeOut
            ) {
                neighbour.transform = .identity
            }.startAnimation()
        }

        animator.startAnimation()
    }
}
