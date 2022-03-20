//
//  Animations.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 13.03.2022.
//

import UIKit

class AnimatorOnboarding: NSObject {
    //

    // MARK: - Related types

    //

    enum Animations {
        case circleAppear
        case circlePositionUp
        case circlePositionRight
        case circleDisappear
        case labelDisappear
    }

    enum CodingKeys: String {
        case animationName
        case nextAnimation

        case labelToBeRemoved
        case circleToBeAnimated
    }

    //

    // MARK: - Public properties

    //

    let window = UIApplication.shared.keyWindow!

    let animatorBackground: AnimatorBackground

    //

    // MARK: - Private properties

    //

    private weak var viewRoot: UIView!

    private weak var viewCircle: UIView!

    private var circleBottomConstraint: NSLayoutConstraint? {
        viewCircle.constraintsAffectingLayout(for: .vertical).first(where: { $0.identifier == "circle.bottom" })
    }

    //

    // MARK: - Initialization

    //

    init(root: UIView, circle: UIView) {
        viewRoot = root
        viewCircle = circle

        animatorBackground = AnimatorBackground(background: root)
    }

    //

    // MARK: - Behaviour

    //

    fileprivate func moveCircleUp() {
        circleBottomConstraint?.constant -= 3 * .r2

        let position = CABasicAnimation(keyPath: "position.y")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.duration = 0.7

        position.fromValue = viewCircle.layer.position.y
        position.toValue = viewCircle.layer.position.y - 3 * .r2

        position.delegate = self
        position.setValue(Animations.circlePositionUp, forKey: CodingKeys.animationName.rawValue)

        viewCircle.layer.add(position, forKey: nil)
    }

    fileprivate func moveCircleRight() {}

    fileprivate func downscaleCircle() {
        viewCircle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        scaleDown.duration = 0.3

        scaleDown.fromValue = 1
        scaleDown.toValue = 0.01

        scaleDown.delegate = self
        scaleDown.setValue(Animations.circleDisappear, forKey: CodingKeys.animationName.rawValue)

        viewCircle.layer.add(scaleDown, forKey: nil)
    }

    //

    // MARK: - Public methods

    //

    func show(label: UILabel) {
        label.isHidden = false
        viewRoot.layoutIfNeeded()

        let group = CAAnimationGroup()
        group.duration = 0.5
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1

        let position = CABasicAnimation(keyPath: "position.y")
        position.fromValue = label.layer.position.y + 30
        position.toValue = label.layer.position.y

        group.animations = [opacity, position]

        label.layer.add(group, forKey: nil)
    }

    func hide(label: UILabel) {
        label.layer.position.y = label.layer.position.y + 30
        label.layer.opacity = 0

        let group = CAAnimationGroup()
        group.duration = 0.5
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        group.delegate = self
        group.setValue(Animations.labelDisappear, forKey: CodingKeys.animationName.rawValue)
        group.setValue(label, forKey: CodingKeys.labelToBeRemoved.rawValue)

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        let position = CABasicAnimation(keyPath: "position.y")
        position.fromValue = label.layer.position.y
        position.toValue = label.layer.position.y + 30

        group.animations = [opacity, position]

        label.layer.add(group, forKey: nil)
    }

    func beginSwipeUpDemonstration() {
        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        scaleUp.duration = 0.3
        scaleUp.fillMode = .backwards

        scaleUp.fromValue = 0.01
        scaleUp.toValue = 1

        scaleUp.delegate = self
        scaleUp.setValue(Animations.circleAppear, forKey: CodingKeys.animationName.rawValue)
        scaleUp.setValue(Animations.circlePositionUp, forKey: CodingKeys.nextAnimation.rawValue)

        viewCircle.layer.add(scaleUp, forKey: nil)
    }
}

//

// MARK: - CAAnimationDelegate

//

extension AnimatorOnboarding: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: CodingKeys.animationName.rawValue) as? Animations, flag else { return }

        switch name {
        case .circleAppear:
            if let next = anim.value(forKey: CodingKeys.nextAnimation.rawValue) as? Animations {
                if next == .circlePositionUp {
                    moveCircleUp()
                } else if next == .circlePositionRight {
                    moveCircleRight()
                }
            }
        case .circlePositionUp:
            downscaleCircle()
        case .circlePositionRight:
            downscaleCircle()
        case .circleDisappear:

            circleBottomConstraint?.constant += 3 * .r2
            viewCircle.transform = .identity

            viewRoot.layoutIfNeeded()

            beginSwipeUpDemonstration()

        case .labelDisappear:
            if let label = anim.value(forKey: CodingKeys.labelToBeRemoved.rawValue) as? UILabel {
                label.isHidden = true
            }
        }
    }
}
