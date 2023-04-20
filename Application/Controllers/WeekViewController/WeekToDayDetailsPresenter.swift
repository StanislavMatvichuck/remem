//
//  WeekToDayDetailsTransitioner.swift
//  Application
//
//  Created by Stanislav Matvichuck on 20.04.2023.
//

import UIKit

final class WeekToDayDetailsPresenter {
    var animatedCellIndex: IndexPath?

    let presentationAnimator = DayDetailsPresentationAnimator()
    let dismissAnimator = DayDetailsDismissAnimator()
    let dismissTransition: UIPercentDrivenInteractiveTransition = {
        let transition = UIPercentDrivenInteractiveTransition()
        transition.wantsInteractiveStart = false
        return transition
    }()
}
