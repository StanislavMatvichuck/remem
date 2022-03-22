//
//  AnimatorCircle.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.03.2022.
//

import UIKit

class AnimatorCircle: NSObject {
    //

    // MARK: - Static properties

    //

    static let verticalTravelDistance: CGFloat = 2 * .d2

    static let horizontalTravelDistance: CGFloat = .d2

    static let fingerTravelDistance: CGFloat = .md

    //

    // MARK: - Related types

    //

    enum Animations {
        case appear
        case positionUp
        case positionRight
        case disappear
    }

    enum CodingKeys: String {
        case animationName
        case nextAnimation
    }

    enum Durations: Double {
        case appear = 0.3
        case positionUp = 0.7
        case disappear = 0.31
    }

    //

    // MARK: - Private properties

    //

    private weak var viewCircle: UIView!

    private weak var viewFinger: UIView!

    private var circleBottomConstraint: NSLayoutConstraint? {
        viewCircle.constraintsAffectingLayout(for: .vertical).first(where: { $0.identifier == "circle.center.y" })
    }

    //

    // MARK: - Initialization

    //

    init(circle: UIView, finger: UIView) {
        viewCircle = circle
        viewFinger = finger
    }

    //

    // MARK: - Behaviour

    //

    fileprivate func circleMovesUp() {
        circleBottomConstraint?.constant -= AnimatorCircle.verticalTravelDistance

        let position = CABasicAnimation(keyPath: "position.y")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.fillMode = .backwards
        position.duration = Durations.positionUp.rawValue

        position.fromValue = viewCircle.layer.position.y
        position.toValue = viewCircle.layer.position.y - AnimatorCircle.verticalTravelDistance

        position.delegate = self
        position.setValue(Animations.positionUp, forKey: CodingKeys.animationName.rawValue)

        viewCircle.layer.add(position, forKey: nil)

        fingerMovesUp()
    }

    fileprivate func fingerMovesUp() {
        let position = CABasicAnimation(keyPath: "position.y")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.fillMode = .backwards
        position.duration = Durations.positionUp.rawValue

        position.fromValue = viewFinger.layer.position.y
        position.toValue = viewFinger.layer.position.y - AnimatorCircle.verticalTravelDistance

        viewFinger.layer.add(position, forKey: nil)
    }

    fileprivate func moveCircleRight() {}

    fileprivate func circleDisappear() {
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.timingFunction = CAMediaTimingFunction(name: .linear)

        scaleDown.duration = Durations.disappear.rawValue

        scaleDown.fromValue = 1
        scaleDown.toValue = 0.01

        scaleDown.delegate = self
        scaleDown.setValue(Animations.disappear, forKey: CodingKeys.animationName.rawValue)

        viewCircle.layer.add(scaleDown, forKey: nil)

        viewCircle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        fingerDisappear()
    }

    fileprivate func fingerDisappear() {
        let group = CAAnimationGroup()
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.duration = Durations.appear.rawValue

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        let translationX = CABasicAnimation(keyPath: "transform.translation.x")
        translationX.fromValue = 0
        translationX.toValue = AnimatorCircle.fingerTravelDistance

        let translationY = CABasicAnimation(keyPath: "transform.translation.y")
        translationY.fromValue = 0
        translationY.toValue = AnimatorCircle.fingerTravelDistance

        group.animations = [opacity, translationX, translationY]

        viewFinger.layer.add(group, forKey: nil)

        viewFinger.layer.opacity = 0
    }

    //

    // MARK: - Public methods

    //

    func circleAppear() {
        viewCircle.transform = .identity

        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.timingFunction = CAMediaTimingFunction(name: .linear)

        scaleUp.duration = Durations.appear.rawValue
        scaleUp.fillMode = .backwards

        scaleUp.fromValue = 0.01
        scaleUp.toValue = 1

        scaleUp.delegate = self
        scaleUp.setValue(Animations.appear, forKey: CodingKeys.animationName.rawValue)
        scaleUp.setValue(Animations.positionUp, forKey: CodingKeys.nextAnimation.rawValue)

        viewCircle.layer.add(scaleUp, forKey: nil)

        fingerAppear()
    }

    fileprivate func fingerAppear() {
        viewFinger.layer.opacity = 1

        let group = CAAnimationGroup()
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.duration = Durations.appear.rawValue

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1

        let translationX = CABasicAnimation(keyPath: "transform.translation.x")
        translationX.fromValue = AnimatorCircle.fingerTravelDistance
        translationX.toValue = 0

        let translationY = CABasicAnimation(keyPath: "transform.translation.y")
        translationY.fromValue = AnimatorCircle.fingerTravelDistance
        translationY.toValue = 0

        group.animations = [opacity, translationX, translationY]

        viewFinger.layer.add(group, forKey: nil)
    }
}

//

// MARK: - CAAnimationDelegate

//

extension AnimatorCircle: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: CodingKeys.animationName.rawValue) as? Animations, flag else { return }

        switch name {
        case .appear:
            if let next = anim.value(forKey: CodingKeys.nextAnimation.rawValue) as? Animations {
                if next == .positionUp {
                    circleMovesUp()
                } else if next == .positionRight {
                    moveCircleRight()
                }
            }
        case .positionUp:
            circleDisappear()

        case .positionRight:
            circleDisappear()

        case .disappear:
            CATransaction.begin()
            circleBottomConstraint?.constant += AnimatorCircle.verticalTravelDistance
            circleAppear()
            CATransaction.commit()
        }
    }
}
