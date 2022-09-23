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

    /// Initializer made to shorten programmatic `UIView` creation
    /// - Parameter al: AutoLayout usage flag
    convenience init(al: Bool) {
        self.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !al
    }

    func animate() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 0.9
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.07
        animation.autoreverses = true
        animation.repeatCount = 1
        layer.add(animation, forKey: nil)
    }

    func catchAttentionWithAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.15
        animation.autoreverses = true
        animation.repeatCount = 1
        layer.add(animation, forKey: nil)
    }
}
