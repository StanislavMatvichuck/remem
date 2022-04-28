//
//  EntryCellAnimator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.04.2022.
//

import UIKit

class EntryCellAnimator: Animator {}

// MARK: - Public
extension EntryCellAnimator {
    func pointAdded(cell: EntryCell, delay: Double = 0.0) {
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

    func handleUnfinishedSwipe(cell: EntryCell) {
        let group = CAAnimationGroup()
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.autoreverses = true
        group.repeatCount = 1
        group.duration = 0.1

        let background = CABasicAnimation(keyPath: "backgroundColor")
        background.fromValue = UIColor.tertiarySystemBackground.cgColor
        background.toValue = UIColor.systemBlue.cgColor

        let size = CABasicAnimation(keyPath: "transform.scale")
        size.fromValue = 1
        size.toValue = .r2 / .r1

        let completion = {
            cell.delegate?.didAnimation(cell)
        }

        group.setValue(completion, forKey: CodingKeys.completionBlock.rawValue)
        group.delegate = self
        group.animations = [background, size]

        pointAdded(cell: cell, delay: 0.2)
        cell.viewMovable.layer.position.x = cell.movableCenterXSuccessPosition
        cell.viewMovable.layer.add(group, forKey: nil)
    }
}
