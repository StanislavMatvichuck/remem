//
//  CountableEventCellAnimator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.04.2022.
//

import UIKit

class CountableEventCellAnimator: Animator {
    private var needsAnimationAfterReuse = false
}

// MARK: - Public
extension CountableEventCellAnimator {
    func handleUnfinishedSwipe(cell: CountableEventCell, delay: Double = 0.0) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = cell.movableCenterXPosition
        animation.toValue = cell.movableCenterXInitialPosition
        animation.duration = 0.3
        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.beginTime = CACurrentMediaTime() + delay

        cell.movableCenterXPosition = cell.movableCenterXInitialPosition
        cell.viewMovable.layer.add(animation, forKey: nil)
    }

    func pointAdded(cell: CountableEventCell) {
        let background = CABasicAnimation(keyPath: "backgroundColor")
        background.fromValue = UIHelper.brandDimmed.cgColor
        background.toValue = UIHelper.brand.cgColor

        let size = CABasicAnimation(keyPath: "transform.scale")
        size.fromValue = 1
        size.toValue = .r2 / .r1

        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.autoreverses = true
        group.repeatCount = 1
        group.duration = 0.1
        group.animations = [background, size]

        cell.viewMovable.layer.position.x = cell.movableCenterXSuccessPosition
        cell.viewMovable.layer.add(group, forKey: nil)
        handleUnfinishedSwipe(cell: cell, delay: 0.2)
    }

    func pressMe(cell: CountableEventCell) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.9
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.repeatCount = .greatestFiniteMagnitude
        animation.autoreverses = true
        cell.viewRoot.layer.add(animation, forKey: "pressMe")
    }

    func removeAnimations(from cell: CountableEventCell) {
        cell.viewRoot.layer.removeAllAnimations()
    }

    func scheduleAnimation() {
        needsAnimationAfterReuse = true
    }

    func animateIfNeeded(cell: CountableEventCell) {
        guard needsAnimationAfterReuse else { return }
        pointAdded(cell: cell)
        needsAnimationAfterReuse = false
    }
}
