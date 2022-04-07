//
//  Animations.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 13.03.2022.
//

import UIKit

class AnimatorOnboarding: NSObject, CAAnimationDelegate {
    //

    // MARK: - Related types

    //

    enum Animations {
        case labelDisappear
    }

    enum CodingKeys: String {
        case animationName
        case nextAnimation

        case labelToBeRemoved
    }

    //

    // MARK: - Private properties

    //

    private var viewRoot: UIView

    //

    // MARK: - Initialization

    //

    init(root: UIView) {
        viewRoot = root
    }

    //

    // MARK: - Public methods

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

    func animate(closeButton: UILabel) {
        closeButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

        let group = CAAnimationGroup()
        group.duration = Animator.standartDuration
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 0.01

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi / 2

        group.animations = [scale, rotation]

        closeButton.layer.add(group, forKey: nil)
    }

    //

    // MARK: CAAnimationDelegate

    //

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: CodingKeys.animationName.rawValue) as? Animations, flag else { return }

        switch name {
        case .labelDisappear:
            if let label = anim.value(forKey: CodingKeys.labelToBeRemoved.rawValue) as? UILabel {
                label.isHidden = true
            }
        }
    }
}
