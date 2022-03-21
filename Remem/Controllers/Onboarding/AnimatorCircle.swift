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
        case positionUp = 0.5
        case disappear = 0.32
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

    fileprivate func moveCircleUp() {
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
    }

    fileprivate func moveCircleRight() {}

    fileprivate func downscaleCircle() {
        viewCircle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.timingFunction = CAMediaTimingFunction(name: .linear)

        scaleDown.duration = Durations.disappear.rawValue

        scaleDown.fromValue = 1
        scaleDown.toValue = 0.01

        scaleDown.delegate = self
        scaleDown.setValue(Animations.disappear, forKey: CodingKeys.animationName.rawValue)

        viewCircle.layer.add(scaleDown, forKey: nil)
    }

    fileprivate func startUpFinger() {}

    fileprivate func moveFingerUp() {
        let position = CABasicAnimation(keyPath: "position.y")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.fillMode = .backwards
        position.duration = Durations.positionUp.rawValue

        position.fromValue = viewFinger.layer.position.y
        position.toValue = viewFinger.layer.position.y - AnimatorCircle.verticalTravelDistance

        viewFinger.layer.add(position, forKey: nil)
    }

    //

    // MARK: - Public methods

    //

    func startUp() {
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
    }

    func startRight() {}
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
                    moveCircleUp()
                    moveFingerUp()
                } else if next == .positionRight {
                    moveCircleRight()
                }
            }

        case .positionUp:
            downscaleCircle()
        case .positionRight:
            downscaleCircle()
        case .disappear:
            CATransaction.begin()
            circleBottomConstraint?.constant += AnimatorCircle.verticalTravelDistance
            viewCircle.transform = .identity
            startUp()
            CATransaction.commit()
        }
    }
}
