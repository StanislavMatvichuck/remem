//
//  AnimatorBackground.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.03.2022.
//

import UIKit

class AnimatorBackground {
    //

    // MARK: - Private properties

    //

    fileprivate weak var viewRoot: UIView!

    fileprivate var startPath: UIBezierPath?

    fileprivate var finalPath: UIBezierPath?

    //

    // MARK: - Initialization

    //

    init(background: UIView) {
        viewRoot = background
    }

    //

    // MARK: - Behaviour

    //

    fileprivate func createStartPath(for frame: CGRect, cornerRadius: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath(rect: viewRoot.bounds)

        path.append(UIBezierPath(roundedRect: CGRect(x: frame.origin.x + frame.width / 2,
                                                     y: frame.origin.y + frame.height / 2,
                                                     width: 0,
                                                     height: 0),
                                 cornerRadius: cornerRadius))

        return path
    }

    fileprivate func createFinalPath(for frame: CGRect, cornerRadius: CGFloat = 0, offset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath(rect: viewRoot.bounds)

        path.append(UIBezierPath(roundedRect: CGRect(x: frame.origin.x - offset,
                                                     y: frame.origin.y - offset,
                                                     width: frame.width + offset * 2,
                                                     height: frame.height + offset * 2),
                                 cornerRadius: cornerRadius))

        return path
    }

    fileprivate func animate(_ flag: Bool) {
        guard
            let startPath = startPath,
            let finalPath = finalPath,
            let maskLayer = viewRoot.layer.mask as? CAShapeLayer
        else { return }

        maskLayer.path = flag ? finalPath.cgPath : startPath.cgPath

        let animation = CABasicAnimation(keyPath: "path")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = ControllerOnboardingOverlay.standartDuration
        animation.fillMode = .backwards

        animation.fromValue = flag ? startPath.cgPath : finalPath.cgPath
        animation.toValue = flag ? finalPath.cgPath : startPath.cgPath

        maskLayer.add(animation, forKey: nil)
    }

    //

    // MARK: - Public methods

    //

    func show(view: UIView, cornerRadius: CGFloat = 0, offset: CGFloat = 0) {
        let projectedFrame = view.convert(view.bounds, to: viewRoot)

        let startPath = createStartPath(for: projectedFrame, cornerRadius: cornerRadius)
        self.startPath = startPath

        let finalPath = createFinalPath(for: projectedFrame, cornerRadius: cornerRadius, offset: offset)
        self.finalPath = finalPath

        let mask: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.path = startPath.cgPath
            layer.fillRule = .evenOdd
            return layer
        }()

        viewRoot.layer.mask = mask

        animate(true)
    }

    // TODO: close animation ending after movement must be closing, not moving
    func move(to view: UIView, cornerRadius: CGFloat = 0.0, offset: CGFloat = 0.0) {
        guard let finalPath = finalPath else {
            return
        }

        let projectedFrame = view.convert(view.bounds, to: viewRoot)

        let startPath = finalPath
        self.startPath = startPath

        let final = createFinalPath(for: projectedFrame, cornerRadius: cornerRadius, offset: offset)
        self.finalPath = final

        let mask: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.path = startPath.cgPath
            layer.fillRule = .evenOdd
            return layer
        }()

        viewRoot.layer.mask = mask

        animate(true)
    }

    func hide() {
        animate(false)
    }
}
