//
//  DayDetailsDismissAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.04.2023.
//

import UIKit

final class DayDetailsDismissAnimator: DayDetailsAnimator {
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        makeAnimator(using: transitionContext)
    }
    
    override func makeAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let detailsView = transitionContext.view(forKey: .from) else { fatalError() }
        
        let duration = transitionDuration(using: transitionContext)
        let height = transitionContext.containerView.frame.maxY
        
        let propertiesAnimator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeOut
        )
        
        propertiesAnimator.addAnimations(DayDetailsAnimationsHelper.makeDismissSliding(
            animatedView: detailsView,
            targetHeight: height
        ))
        
        for animation in additionalAnimations {
            propertiesAnimator.addAnimations(animation)
        }
        
        propertiesAnimator.addCompletion { _ in
            let isComplete = !transitionContext.transitionWasCancelled
            if isComplete { detailsView.removeFromSuperview() }
            transitionContext.completeTransition(isComplete)
        }
        
        return propertiesAnimator
    }
}
