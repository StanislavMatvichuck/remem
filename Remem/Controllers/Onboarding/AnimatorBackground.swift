//
//  AnimatorBackground.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.03.2022.
//

import UIKit

class AnimatorBackground: Animator {
    // MARK: - Private properties
    private var viewRoot: UIView
    /// These properties are updated by `shownPath` and `moveShownArea` methods
    private var lastShownPath: UIBezierPath?
    private var lastShownInnerRect: UIBezierPath?
    private var lastShownCornerRadius: CGFloat?
    private var lastHiddenPath: UIBezierPath?

    // MARK: - Init
    init(_ viewWithAnimatedMask: UIView) {
        viewRoot = viewWithAnimatedMask
        super.init()
        setupMask()
    }

    private func setupMask() {
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(rect: UIScreen.main.bounds).cgPath
        mask.fillRule = .evenOdd
        viewRoot.layer.mask = mask
    }
}

// MARK: - Private
extension AnimatorBackground {
    private var outerRectanglePath: UIBezierPath { UIBezierPath(rect: viewRoot.bounds) }

    private func hiddenPath(for view: UIView, cornerRadius: CGFloat = 0) -> UIBezierPath {
        let frame = view.convert(view.bounds, to: viewRoot)
        let path = outerRectanglePath
        let innerRectangle = UIBezierPath(
            roundedRect: CGRect(x: frame.origin.x + frame.width / 2,
                                y: frame.origin.y + frame.height / 2,
                                width: 0,
                                height: 0),
            cornerRadius: cornerRadius)
        path.append(innerRectangle)
        lastHiddenPath = path
        return path
    }

    private func shownPath(for view: UIView, cornerRadius: CGFloat = 0, offset: CGFloat = 0) -> UIBezierPath {
        let frame = view.convert(view.bounds, to: viewRoot)
        let path = outerRectanglePath
        let innerRectangle = UIBezierPath(
            roundedRect: CGRect(x: frame.origin.x - offset,
                                y: frame.origin.y - offset,
                                width: frame.width + offset * 2,
                                height: frame.height + offset * 2),
            cornerRadius: cornerRadius)
        path.append(innerRectangle)

        lastShownPath = path
        lastShownInnerRect = innerRectangle
        lastShownCornerRadius = cornerRadius

        return path
    }

    private func animate(from: UIBezierPath, to: UIBezierPath,
                         duration: Double = Animator.standartDuration,
                         completion: CompletionBlock? = nil)
    {
        guard let mask = viewRoot.layer.mask as? CAShapeLayer else { return }

        let animation = CABasicAnimation(keyPath: "path")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.fillMode = .backwards
        animation.fromValue = from.cgPath
        animation.toValue = to.cgPath

        animation.delegate = self
        animation.setValue(completion, forKey: CodingKeys.completionBlock.rawValue)

        mask.path = to.cgPath
        mask.add(animation, forKey: nil)
    }
}

// MARK: - Public
extension AnimatorBackground {
    func show(view: UIView, cornerRadius: CGFloat = 0, offset: CGFloat = 0, completion: CompletionBlock? = nil) {
        let start = hiddenPath(for: view, cornerRadius: cornerRadius)
        let final = shownPath(for: view, cornerRadius: cornerRadius, offset: offset)
        animate(from: start, to: final, completion: completion)
    }

    func hide(_ completion: CompletionBlock? = nil) {
        guard
            let start = lastShownPath,
            let finish = lastHiddenPath
        else { return }

        animate(from: start, to: finish, completion: completion)
    }

    func move(to view: UIView, cornerRadius: CGFloat = 0.0, offset: CGFloat = 0.0) {
        guard let start = lastShownPath else { return }
        let final = shownPath(for: view, cornerRadius: cornerRadius, offset: offset)
        animate(from: start, to: final)
    }

    func moveShownArea(by: CGPoint, duration: Double = Animator.standartDuration) {
        guard
            let start = lastShownPath,
            let inner = lastShownInnerRect,
            let radius = lastShownCornerRadius
        else { return }

        let newInnerRectangle = UIBezierPath(
            roundedRect: CGRect(x: inner.bounds.origin.x + by.x,
                                y: inner.bounds.origin.y + by.y,
                                width: inner.bounds.size.width,
                                height: inner.bounds.size.height),
            cornerRadius: radius)

        let final = outerRectanglePath
        final.append(newInnerRectangle)

        lastShownPath = final
        lastShownInnerRect = newInnerRectangle

        animate(from: start, to: final, duration: duration)
    }
}
