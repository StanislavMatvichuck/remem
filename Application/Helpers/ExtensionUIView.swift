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
}
