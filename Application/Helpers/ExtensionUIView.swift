//
//  ExtensionUIView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

extension UIView {
    func addAndConstrain(_ view: UIView, constant: CGFloat = 0) {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            view.topAnchor.constraint(equalTo: topAnchor, constant: constant),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * constant),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * constant),
        ])
    }

    func addAndConstrain(
        _ subview: UIView,
        top: CGFloat = 0,
        left: CGFloat = 0,
        right: CGFloat = 0,
        bottom: CGFloat = 0
    ) {
        addSubview(subview)
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: left),
            subview.topAnchor.constraint(equalTo: topAnchor, constant: top),
            subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -right),
            subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottom),
        ])
    }

    /// Initializer made to shorten programmatic `UIView` creation
    /// - Parameter al: AutoLayout usage flag
    convenience init(al: Bool) {
        self.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !al
    }

    func animateTapReceiving(completionHandler: (() -> Void)? = nil) {
        class AnimationDelegate: NSObject, CAAnimationDelegate {
            let completionHandler: (() -> Void)?
            init(completionHandler: (() -> Void)? = nil) {
                self.completionHandler = completionHandler
            }

            func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
                if flag { completionHandler?() }
            }
        }

        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.9
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.07
        animation.autoreverses = true
        animation.repeatCount = 1
        animation.delegate = AnimationDelegate(completionHandler: completionHandler)

        UIDevice.vibrate(.medium)
        layer.add(animation, forKey: nil)
    }

    func animateEmoji() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.75
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.15
        animation.autoreverses = true
        animation.repeatCount = 1
        layer.add(animation, forKey: nil)
    }

    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y)

        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)

        var position = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        layer.position = position
        layer.anchorPoint = point
    }
}

extension UIView {
    func installDotsPattern(_ rows: Int = 1) {
        let patternLayer = makePatternLayer()

        let horizontalReplicator = makeReplicatorLayer(
            layer: patternLayer,
            count: columns,
            x: .layoutSquare, y: 0
        )

        let verticalReplicator = makeReplicatorLayer(
            layer: horizontalReplicator,
            count: rows,
            x: 0, y: .layoutSquare
        )

        layer.addSublayer(verticalReplicator)
    }

    private var columns: Int { 7 }

    private func makePatternLayer() -> CALayer {
        let frame = CGRect(
            origin: .zero,
            size: CGSize(
                width: .layoutSquare,
                height: .layoutSquare
            )
        )
        let patternLayer = CAShapeLayer()
        patternLayer.frame = frame
        patternLayer.path = makePatternPath().cgPath
        patternLayer.fillColor = UIColor.secondary.withAlphaComponent(1.0).cgColor
        patternLayer.mask = makeMaskLayer()
        return patternLayer
    }

    private func makeReplicatorLayer(
        layer: CALayer,
        count: Int,
        x: CGFloat,
        y: CGFloat
    ) -> CALayer {
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, x, y, 0)

        let replicator = CAReplicatorLayer()
        replicator.instanceTransform = transform
        replicator.instanceCount = count
        replicator.addSublayer(layer)
        replicator.frame = bounds

        return replicator
    }

    private func makePatternPath() -> UIBezierPath {
        let circleRadius = .layoutSquare / 32
        let circleSize = CGSize(width: 2 * circleRadius, height: 2 * circleRadius)
        let x = -circleRadius
        let y = -circleRadius

        let path = UIBezierPath()

        for point in [
            CGPoint(x: x, y: y),
            CGPoint(x: x + .layoutSquare, y: y),
            CGPoint(x: x + .layoutSquare, y: y + .layoutSquare),
            CGPoint(x: x, y: y + .layoutSquare),
        ] {
            path.append(UIBezierPath(ovalIn: CGRect(
                origin: point,
                size: circleSize
            )))
        }

        return path
    }

    private func makeMaskLayer() -> CALayer {
        let patternMaskLayer = CAShapeLayer()
        patternMaskLayer.path = UIBezierPath(rect: CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(
                width: .layoutSquare,
                height: .layoutSquare
            )
        )).cgPath
        return patternMaskLayer
    }
}
