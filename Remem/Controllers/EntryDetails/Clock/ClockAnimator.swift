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
    private var isAnimatedOnce = false
    private let dayClock: UIView
    private let nightClock: UIView

    init(dayClock: UIView, nightClock: UIView) {
        self.dayClock = dayClock
        self.nightClock = nightClock
        nightClock.isHidden = true
    }
}

// MARK: - Public
extension ClockAnimator {
    func flip() {
        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        let firstView = isDayClockVisible ? dayClock : nightClock
        let secondView = isDayClockVisible ? nightClock : dayClock

        UIView.transition(from: firstView, to: secondView, duration: 0.6, options: transitionOptions) { finished in
            guard finished else { return }
            self.isDayClockVisible.toggle()
        }
    }

    func appearForward() {
        guard !isAnimatedOnce else { return }

        let animation = makeAppearAnimation()
        let mask = createMaskLayer()
        mask.add(animation, forKey: nil)
        mask.strokeEnd = 1.0

        dayClock.layer.mask = mask
        dayClock.layer.opacity = 1.0
        isAnimatedOnce = true
    }
}

// MARK: - Private
extension ClockAnimator {
    private func makeAppearAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.15
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }

    private func createMaskLayer() -> CAShapeLayer {
        let center = dayClock.center
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: center.x, y: center.y),
                                      radius: center.y / 2,
                                      startAngle: -89.99 * CGFloat.pi / 180,
                                      endAngle: -90 * CGFloat.pi / 180,
                                      clockwise: true)

        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = center.y
        circleLayer.strokeEnd = 0.0

        return circleLayer
    }
}
