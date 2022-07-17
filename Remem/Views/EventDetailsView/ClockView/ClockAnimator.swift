//
//  ClockAnimator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 16.05.2022.
//

import UIKit

class ClockAnimator {
    // MARK: - Properties
    private var isDayClockVisible = true
}

// MARK: - Public
extension ClockAnimator {
    func flip(dayClock: UIView, nightClock: UIView) {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        let firstView = isDayClockVisible ? dayClock : nightClock
        let secondView = isDayClockVisible ? nightClock : dayClock

        UIView.transition(from: firstView, to: secondView, duration: 0.6, options: transitionOptions) { finished in
            guard finished else { return }
            self.isDayClockVisible.toggle()
        }
    }
}
