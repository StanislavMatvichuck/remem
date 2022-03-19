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

    enum OnboardingAnimationsNames {
        case circleSwipeUp
        case labelDisappear
    }

    enum OnboardingCodingKeys: String {
        case animationName
        case nextAnimation

        case labelToBeRemoved
        case circleToBeAnimated
    }

    enum OnboardingSwipeAnimationVariants {
        case bottomTop
        case leftRight
    }

    //

    // MARK: - Private properties

    //

    let window = UIApplication.shared.keyWindow!

    private weak var viewBackground: UIView!

    private weak var animationsDelegate: CAAnimationDelegate!

    //

    // MARK: - Initialization

    //

    init(background: UIView, delegate: CAAnimationDelegate) {
        viewBackground = background
        animationsDelegate = delegate
    }

    //

    // MARK: - Behaviour

    //

    func createAppearAnimation(for label: UILabel) -> CAAnimationGroup {
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

        return group
    }

    func createDisappearAnimation(for label: UILabel) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.isRemovedOnCompletion = true

        group.setValue(OnboardingAnimationsNames.labelDisappear, forKey: OnboardingCodingKeys.animationName.rawValue)
        group.setValue(label, forKey: OnboardingCodingKeys.labelToBeRemoved.rawValue)
        group.delegate = animationsDelegate

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        let position = CABasicAnimation(keyPath: "position.y")
        position.fromValue = label.layer.position.y
        position.toValue = label.layer.position.y + 30

        group.animations = [opacity, position]

        return group
    }

    func createSwipeUpAnimation(for circle: UIView) -> CABasicAnimation {
        //
        // Scale up
        //

        let scaleUp = CABasicAnimation(keyPath: "transform.scale")
        scaleUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        scaleUp.isRemovedOnCompletion = true

        scaleUp.duration = 0.3
        scaleUp.fillMode = .backwards

        scaleUp.fromValue = 0.01
        scaleUp.toValue = 1

//        scaleUp.setValue(OnboardingAnimationsNames.circleSwipeUp, forKey: OnboardingCodingKeys.animationName.rawValue)
//        scaleUp.delegate = self

        //
        // Position
        //

//        let position = CABasicAnimation(keyPath: "position.y")
//        position.timingFunction = CAMediaTimingFunction(name: .easeOut)
//        position.isRemovedOnCompletion = true
//        position.fillMode = .backwards
//        position.duration = 0.7
//
//        position.fromValue = circle.layer.position.y
//        position.toValue = circle.layer.position.y - 3 * .r2
//
//        position.delegate = self
//
//        circle.layer.position.y = circle.layer.position.y - 3 * .r2
//        circle.layer.add(position, forKey: nil)

        //
        // Scale down
        //

//        let scaleDown = CABasicAnimation(keyPath: "transform.scale")
//        scaleDown.duration = 0.3
//        scaleDown.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        scaleDown.fillMode = .backwards
//        scaleDown.fromValue = 1
//        scaleDown.toValue = 0.01
//        scaleDown.isRemovedOnCompletion = true
//
//        scaleDown.delegate = self
//
//        circle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
//        circle.layer.add(scaleDown, forKey: nil)

        //
        // Repeat
        //

//        viewCircle.layer.position.y = viewCircle.layer.position.y + 3 * .r2
//        viewCircle.transform = CGAffineTransform.identity
//        animateCircle(with: .bottomTop)

        return scaleUp
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

        let path = UIBezierPath(rect: viewBackground.bounds)

        path.append(UIBezierPath(roundedRect: CGRect(x: centerX,
                                                     y: centerY,
                                                     width: 0,
                                                     height: 0),
                                 cornerRadius: cornerRadius))

        return path
    }

    private func createFinalPath(for frame: CGRect, cornerRadius: CGFloat = 0, offset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath(rect: viewBackground.bounds)

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
            let maskLayer = viewBackground.layer.mask as? CAShapeLayer
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

        viewBackground.layer.mask = backgroundOverlay

        addAnimationToMaskLayer(willShowHighlight: true)
    }
}
