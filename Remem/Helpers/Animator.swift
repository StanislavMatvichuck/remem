//
//  Animator.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

class Animator: NSObject {
    // MARK: - Type properties
    typealias CompletionBlock = () -> Void

    enum CodingKeys: String {
        case completionBlock
    }

    // MARK: - Properties
    static let standartDuration = TimeInterval(0.3)
}

// MARK: - CAAnimationDelegate
extension Animator: CAAnimationDelegate {
    /// super.animationDidStop() must be called on subclasses if overridden
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag, let completion = anim.value(
            forKey: CodingKeys.completionBlock.rawValue)
            as? CompletionBlock
        {
            completion()
        }
    }
}
