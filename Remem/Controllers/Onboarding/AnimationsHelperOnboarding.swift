//
//  Animations.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 13.03.2022.
//

import UIKit

class AnimationsHelperOnboarding: NSObject {
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

    // MARK: - Private properties

    //

    let window = UIApplication.shared.keyWindow!

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
    }

    //

    // MARK: - Behaviour

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

    // MARK: Highlighting

    //

    private var startPath: UIBezierPath?

    private var finalPath: UIBezierPath?

    private func createProjectedFrame(for view: UIView) -> CGRect {
        let windowView = window.rootViewController!.view

        let frame = view.convert(view.bounds, to: windowView)

        return frame
    }

    private func createStartPath(for frame: CGRect, cornerRadius: CGFloat = 0) -> UIBezierPath {
        let centerX = frame.origin.x + frame.width / 2
        let centerY = frame.origin.y + frame.height / 2

        let path = UIBezierPath(rect: viewRoot.bounds)

        path.append(UIBezierPath(roundedRect: CGRect(x: centerX,
                                                     y: centerY,
                                                     width: 0,
                                                     height: 0),
                                 cornerRadius: cornerRadius))

        return path
    }

    private func createFinalPath(for frame: CGRect, cornerRadius: CGFloat = 0, offset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath(rect: viewRoot.bounds)

        let finalRect = CGRect(x: frame.origin.x - offset,
                               y: frame.origin.y - offset,
                               width: frame.width + offset * 2,
                               height: frame.height + offset * 2)

        path.append(UIBezierPath(roundedRect: finalRect, cornerRadius: cornerRadius))

        return path
    }

    func addAnimationToMaskLayer(willShowHighlight: Bool) {
        guard
            let startPath = startPath,
            let finalPath = finalPath,
            let maskLayer = viewRoot.layer.mask as? CAShapeLayer
        else { return }

        let animation = CABasicAnimation(keyPath: "path")

        animation.fromValue = willShowHighlight ? startPath.cgPath : finalPath.cgPath
        animation.toValue = willShowHighlight ? finalPath.cgPath : startPath.cgPath
        animation.duration = ControllerOnboardingOverlay.standartDuration
        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)

        maskLayer.add(animation, forKey: nil)
        maskLayer.path = willShowHighlight ? finalPath.cgPath : startPath.cgPath
    }

    func animateMaskLayer(for view: UIView?, cornerRadius: CGFloat = 0, offset: CGFloat = 0) {
        guard let highlightedView = view else { return }

        let projectedFrame = createProjectedFrame(for: highlightedView)

        let startPath = createStartPath(for: projectedFrame, cornerRadius: cornerRadius)
        self.startPath = startPath

        let finalPath = createFinalPath(for: projectedFrame, cornerRadius: cornerRadius, offset: offset)
        self.finalPath = finalPath

        let backgroundOverlay: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.path = startPath.cgPath
            layer.fillRule = .evenOdd
            return layer
        }()

        viewRoot.layer.mask = backgroundOverlay

        addAnimationToMaskLayer(willShowHighlight: true)
    }
}

//

// MARK: - CAAnimationDelegate

//

extension AnimationsHelperOnboarding: CAAnimationDelegate {
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
