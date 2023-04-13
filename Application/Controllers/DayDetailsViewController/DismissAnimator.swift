//
//  DayDetailsDismissAnimator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.04.2023.
//

import UIKit

final class DismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval { DayDetailsAnimationsHelper.totalDuration }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        interruptibleAnimator(using: transitionContext).startAnimation()
    }
    
    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        guard let detailsView = transitionContext.view(forKey: .from) else { fatalError() }
        
        let duration = transitionDuration(using: transitionContext)
        let height = transitionContext.containerView.frame.maxY
        
        let propertiesAnimator = UIViewPropertyAnimator(
            duration: duration,
            curve: .easeOut
        )
        
        propertiesAnimator.addAnimations(DayDetailsAnimationsHelper.makeDismissSliding(
            duration: duration,
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
    
    func prepareForAnimation(_ view: UIView) {
        view.frame.origin.y = .layoutSquare * -4
        view.transform = .init(scaleX: 0.8, y: 1)
    }
    
    private var additionalAnimations: [() -> Void] = []
    
    func add(_ animation: @escaping () -> Void) {
        additionalAnimations.append(animation)
    }
    
    func clearAdditionalAnimations() {
        additionalAnimations = []
    }
}
