//
//  Animations.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 13.03.2022.
//

import UIKit

class AnimatorOnboarding: Animator {
    // MARK: - Related types
    enum Animations {
        case labelDisappear
    }

    enum OnboardingCodingKeys: String {
        case name
        case labelToBeRemoved
    }

    // MARK: - Private properties
    private var viewRoot: UIView

    // MARK: - Init
    init(root: UIView) { viewRoot = root }

    // MARK: - Public methods
    func show(labels: UILabel..., completion: CompletionBlock? = nil) {
        labels.forEach { $0.isHidden = false }
        viewRoot.layoutIfNeeded()

        for (index, label) in labels.enumerated() {
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

            // add callback to last animation
            if index == labels.count - 1 {
                group.delegate = self
                group.setValue(completion, forKey: CodingKeys.completionBlock.rawValue)
            }

            label.layer.add(group, forKey: nil)
        }
    }

    func hide(labels: UILabel..., completion: CompletionBlock? = nil) {
        for (index, label) in labels.enumerated() {
            label.layer.opacity = 0

            let group = CAAnimationGroup()
            group.duration = 0.5
            group.fillMode = .backwards
            group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

            group.delegate = self
            group.setValue(Animations.labelDisappear, forKey: OnboardingCodingKeys.name.rawValue)
            group.setValue(label, forKey: OnboardingCodingKeys.labelToBeRemoved.rawValue)

            // add callback to last animation
            if index == labels.count - 1 {
                group.setValue(completion, forKey: CodingKeys.completionBlock.rawValue)
            }

            let opacity = CABasicAnimation(keyPath: "opacity")
            opacity.fromValue = 1
            opacity.toValue = 0

            let position = CABasicAnimation(keyPath: "position.y")
            position.fromValue = label.layer.position.y
            position.toValue = label.layer.position.y + 30

            group.animations = [opacity, position]

            label.layer.add(group, forKey: nil)
        }
    }
}

// MARK: - CAAnimationDelegate
extension AnimatorOnboarding {
    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        super.animationDidStop(anim, finished: flag)

        guard flag else { return }

        if let name = anim.value(
            forKey: OnboardingCodingKeys.name.rawValue)
            as? Animations
        {
            switch name {
            case .labelDisappear:
                if let label = anim.value(
                    forKey: OnboardingCodingKeys.labelToBeRemoved.rawValue)
                    as? UILabel
                {
                    label.isHidden = true
                }
            }
        }
    }
}
