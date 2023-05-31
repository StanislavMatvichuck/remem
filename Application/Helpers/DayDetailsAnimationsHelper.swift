//
//  DayDetailsAnimationsHelper.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.04.2023.
//

import UIKit

struct DayDetailsAnimationsHelper {
    typealias AnimationBlock = () -> Void
    static let frameDuration = TimeInterval(1.0 / 60.0)
    static let totalDuration = DayDetailsAnimationsHelper.frameDuration * 30
    static let cellVerticalOffset = .layoutSquare * 5 + .buttonMargin

    static func makeDismissSliding(
        animatedView: UIView,
        targetHeight: CGFloat
    ) -> AnimationBlock {{
        UIView.animateKeyframes(
            withDuration: totalDuration,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 5 / 6
                ) {
                    animatedView.frame.origin.y = targetHeight
                }

                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 1 / 6
                ) {
                    animatedView.transform = CGAffineTransform(scaleX: 0.9, y: 1)
                }
            }
        )
    }}

    static func makePresentationSliding(
        animatedView: UIView,
        targetHeight: CGFloat
    ) -> AnimationBlock {{
        UIView.animateKeyframes(
            withDuration: totalDuration,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 5 / 6
                ) {
                    animatedView.frame.origin.y = targetHeight
                }

                UIView.addKeyframe(
                    withRelativeStartTime: 4 / 6,
                    relativeDuration: 1 / 6
                ) {
                    animatedView.transform = .identity
                }
            }
        )
    }}

    static func makeCellPresentationSliding(
        animatedView: UIView
    ) -> AnimationBlock {{
        UIView.animateKeyframes(
            withDuration: totalDuration,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 1 / 3,
                    animations: {
                        animatedView.frame.origin.y -= Self.cellVerticalOffset
                    }
                )

                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 1 / 6,
                    animations: {
                        animatedView.transform = .init(scaleX: 0.8, y: 1)
                    }
                )
            }
        )
    }}

    static func makeBackgroundPresentation(
        animatedView: UIView
    ) -> AnimationBlock {{
        UIView.animateKeyframes(
            withDuration: totalDuration,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0.5,
                    relativeDuration: 0.5,
                    animations: {
                        animatedView.alpha = 0.5
                    }
                )
            }
        )
    }}

    static func makeCellDismissal(
        animatedView: UIView
    ) -> AnimationBlock {{
        UIView.animateKeyframes(
            withDuration: totalDuration,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 3 / 6,
                    relativeDuration: 1 / 2,
                    animations: {
                        animatedView.frame.origin.y += Self.cellVerticalOffset
                    }
                )

                UIView.addKeyframe(
                    withRelativeStartTime: 5 / 6,
                    relativeDuration: 1 / 6,
                    animations: {
                        animatedView.transform = .identity
                    }
                )
            }
        )
    }}

    static func makeBackgroundDismissal(
        animatedView: UIView
    ) -> AnimationBlock {{
        UIView.animateKeyframes(
            withDuration: totalDuration,
            delay: 0,
            animations: {
                UIView.addKeyframe(
                    withRelativeStartTime: 0,
                    relativeDuration: 0.5,
                    animations: {
                        animatedView.alpha = 0
                    }
                )
            }
        )
    }}
}
