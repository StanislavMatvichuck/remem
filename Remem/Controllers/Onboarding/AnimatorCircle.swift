//
//  AnimatorCircle.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.03.2022.
//

import UIKit

class AnimatorCircle: NSObject {
    //

    // MARK: - Related types

    //

    enum Mode {
        case addItem
        case addPoint
    }

    enum Animations {
        case appear
        case position
        case disappear
    }

    enum CodingKeys: String {
        case animationName
    }

    enum Durations: Double {
        case appear = 0.3
        case position = 0.7
        case disappear = 0.31
    }

    //

    // MARK: - Private properties

    //

    fileprivate var mode = Mode.addItem
    fileprivate var lastIteration = false

    fileprivate let verticalTravelDistance: CGFloat = 2 * .d2
    fileprivate let horizontalTravelDistance: CGFloat = .wScreen - 2 * .delta1 - .d2
    fileprivate let fingerTravelDistance: CGFloat = .md

    fileprivate weak var circle: UIView!
    fileprivate weak var finger: UIView!
    fileprivate weak var background: UIView!

    fileprivate var circleY: NSLayoutConstraint!
    fileprivate var circleX: NSLayoutConstraint!

    //

    // MARK: - Initialization

    //

    init(circle: UIView, finger: UIView, background: UIView) {
        self.circle = circle
        self.finger = finger
        self.background = background
    }

    //

    // MARK: - Behaviour

    //

    fileprivate func setupConstraints() {
        guard let parentView = circle.superview else { return }

        circle.removeFromSuperview()
        finger.removeFromSuperview()

        parentView.addSubview(circle)
        parentView.addSubview(finger)

        switch mode {
        case .addItem:
            circleY = circle.centerYAnchor.constraint(equalTo: background.centerYAnchor, constant: verticalTravelDistance / 2)
            circleX = circle.centerXAnchor.constraint(equalTo: background.centerXAnchor)
        case .addPoint:
            circleY = circle.centerYAnchor.constraint(equalTo: background.safeAreaLayoutGuide.bottomAnchor, constant: -.r2 - .delta1 / 2)
            circleX = circle.centerXAnchor.constraint(equalTo: background.leadingAnchor, constant: .r2 + .delta1)
        }

        setupViewFingerConstraints()

        NSLayoutConstraint.activate([circleX, circleY])
    }

    fileprivate func setupViewFingerConstraints() {
        let labelSize = finger.sizeThatFits(CGSize(width: .wScreen, height: .hScreen))

        NSLayoutConstraint.activate([
            finger.centerXAnchor.constraint(equalTo: circle.centerXAnchor, constant: labelSize.width / 1.6 + 7),
            finger.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: labelSize.height / 1.6 + 2),
        ])
    }

    fileprivate func startAppearing() {
        circle.transform = .identity

        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.timingFunction = CAMediaTimingFunction(name: .linear)

        scaleUp.duration = Durations.appear.rawValue
        scaleUp.fillMode = .backwards

        scaleUp.fromValue = 0.01
        scaleUp.toValue = 1

        scaleUp.delegate = self
        scaleUp.setValue(Animations.appear, forKey: CodingKeys.animationName.rawValue)

        circle.layer.add(scaleUp, forKey: nil)

        fingerAppear()
    }

    fileprivate func fingerAppear() {
        finger.layer.opacity = 1

        let group = CAAnimationGroup()
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .linear)
        group.duration = Durations.appear.rawValue

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1

        let translationX = CABasicAnimation(keyPath: "transform.translation.x")
        translationX.fromValue = fingerTravelDistance
        translationX.toValue = 0

        let translationY = CABasicAnimation(keyPath: "transform.translation.y")
        translationY.fromValue = fingerTravelDistance
        translationY.toValue = 0

        group.animations = [opacity, translationX, translationY]

        finger.layer.add(group, forKey: nil)
    }

    fileprivate func startMovement() {
        switch mode {
        case .addItem:
            circleMovesUp()
        case .addPoint:
            circleMovesRight()
        }
    }

    fileprivate func circleMovesUp() {
        circleY.constant -= verticalTravelDistance

        let position = CABasicAnimation(keyPath: "position.y")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.fillMode = .backwards
        position.duration = Durations.position.rawValue

        position.fromValue = circle.layer.position.y
        position.toValue = circle.layer.position.y - verticalTravelDistance

        position.delegate = self
        position.setValue(Animations.position, forKey: CodingKeys.animationName.rawValue)

        circle.layer.add(position, forKey: nil)

        fingerMovesUp()
    }

    fileprivate func fingerMovesUp() {
        let position = CABasicAnimation(keyPath: "position.y")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.fillMode = .backwards
        position.duration = Durations.position.rawValue

        position.fromValue = finger.layer.position.y
        position.toValue = finger.layer.position.y - verticalTravelDistance

        finger.layer.add(position, forKey: nil)
    }

    fileprivate func circleMovesRight() {
        circleX.constant += horizontalTravelDistance

        let position = CABasicAnimation(keyPath: "position.x")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.fillMode = .backwards
        position.duration = Durations.position.rawValue

        position.fromValue = circle.layer.position.x
        position.toValue = circle.layer.position.x + horizontalTravelDistance

        position.delegate = self
        position.setValue(Animations.position, forKey: CodingKeys.animationName.rawValue)

        circle.layer.add(position, forKey: nil)

        fingerMovesRight()
    }

    fileprivate func fingerMovesRight() {
        let position = CABasicAnimation(keyPath: "position.x")
        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
        position.fillMode = .backwards
        position.duration = Durations.position.rawValue

        position.fromValue = finger.layer.position.x
        position.toValue = finger.layer.position.x + horizontalTravelDistance

        finger.layer.add(position, forKey: nil)
    }

    fileprivate func startDisappearing() {
        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
        scaleDown.timingFunction = CAMediaTimingFunction(name: .linear)

        scaleDown.duration = Durations.disappear.rawValue

        scaleDown.fromValue = 1
        scaleDown.toValue = 0.01

        scaleDown.delegate = self
        scaleDown.setValue(Animations.disappear, forKey: CodingKeys.animationName.rawValue)

        circle.layer.add(scaleDown, forKey: nil)

        circle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

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
        translationX.toValue = fingerTravelDistance

        let translationY = CABasicAnimation(keyPath: "transform.translation.y")
        translationY.fromValue = 0
        translationY.toValue = fingerTravelDistance

        group.animations = [opacity, translationX, translationY]

        finger.layer.add(group, forKey: nil)

        finger.layer.opacity = 0
    }

    fileprivate func reset() {
        CATransaction.begin()

        switch mode {
        case .addItem:
            circleY.constant += verticalTravelDistance
        case .addPoint:
            circleX.constant -= horizontalTravelDistance
        }

        startAppearing()
        CATransaction.commit()
    }

    //

    // MARK: - Public methods

    //

    func start(_ mode: Mode) {
        self.mode = mode
        lastIteration = false

        setupConstraints()

        circle.isHidden = false
        finger.isHidden = false

        startAppearing()
    }

    func stop() {
        lastIteration = true
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
            startMovement()
        case .position:
            startDisappearing()
        case .disappear:
            if !lastIteration {
                reset()
            }
        }
    }
}
