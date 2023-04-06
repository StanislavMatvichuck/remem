//
//  WeekCellAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.04.2023.
//

import UIKit

struct WeekCellAnimator {
    let collection: UICollectionView
    var index: IndexPath?

    func animateBeforePresentation() {
        guard let index, let cell = collection.cellForItem(at: index) else { return }

        UIView.animate(
            withDuration: AnimationsHelper.weekItemPositionYDuration,
            animations: {
                cell.frame.origin.y -= .layoutSquare * 4
            })

        UIView.animate(
            withDuration: AnimationsHelper.scaleXDuration,
            animations: {
                cell.transform = .init(scaleX: 0.8, y: 1)
            })
    }

    func animateAfterDismiss() {
        guard let index, let cell = collection.cellForItem(at: index) else { return }

        prepareForAnimation(cell)

        UIView.animate(
            withDuration: AnimationsHelper.weekItemPositionYDuration,
            delay: AnimationsHelper.weekItemPositionYDelay,
            animations: {
                cell.frame.origin.y += .layoutSquare * 4
            })

        UIView.animate(
            withDuration: AnimationsHelper.scaleXDuration,
            delay: AnimationsHelper.weekItemScaleXDelay,
            animations: {
                cell.transform = .init(scaleX: 1, y: 1)
            })
    }

    func prepareForAnimation(_ view: UIView) {
        view.frame.origin.y = .layoutSquare * -4
        view.transform = .init(scaleX: 0.8, y: 1)
    }
}
