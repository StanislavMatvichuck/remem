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
        case name
        case completionBlock

        case labelToBeRemoved
    }

    typealias AnimationCompletionBlock = () -> Void

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

    func show(label: UILabel, completion: AnimationCompletionBlock? = nil) {
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

        group.delegate = self
        group.setValue(completion, forKey: CodingKeys.completionBlock.rawValue)

        label.layer.add(group, forKey: nil)
    }

    func hide(label: UILabel, completion: AnimationCompletionBlock? = nil) {
        label.layer.opacity = 0

        let group = CAAnimationGroup()
        group.duration = 0.5
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        group.delegate = self
        group.setValue(Animations.labelDisappear, forKey: CodingKeys.name.rawValue)
        group.setValue(label, forKey: CodingKeys.labelToBeRemoved.rawValue)
        group.setValue(completion, forKey: CodingKeys.completionBlock.rawValue)

        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        let position = CABasicAnimation(keyPath: "position.y")
        position.fromValue = label.layer.position.y
        position.toValue = label.layer.position.y + 30

        group.animations = [opacity, position]

        label.layer.add(group, forKey: nil)
    }

    //

    // MARK: CAAnimationDelegate

    //

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if
            flag,
            let completion = anim.value(forKey: CodingKeys.completionBlock.rawValue) as? AnimationCompletionBlock
        {
            completion()
        }

        guard
            flag,
            let name = anim.value(forKey: CodingKeys.name.rawValue) as? Animations
        else { return }

        switch name {
        case .labelDisappear:
            if let label = anim.value(forKey: CodingKeys.labelToBeRemoved.rawValue) as? UILabel {
                label.isHidden = true
            }
        }
    }
}
