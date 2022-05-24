//
//  ClockController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class ClockController: UIViewController {
    // MARK: - Properties
    fileprivate let viewRoot = ClockView()

    var clockService: ClockService!

    private var clockAnimator: ClockAnimator!

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        clockAnimator = ClockAnimator(dayClock: viewRoot.clockDay,
                                      nightClock: viewRoot.clockNight)
        clockService.fetch()
        viewRoot.clockDay.sectionsList = clockService.daySectionsList
        viewRoot.clockNight.sectionsList = clockService.nightSectionsList

        viewRoot.clockDay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClockPress)))
        viewRoot.clockNight.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleClockPress)))
    }

    override func viewDidAppear(_ animated: Bool) {
        clockAnimator.appearForward()
    }
}

// MARK: - User input
extension ClockController {
    @objc func handleClockPress() {
        clockAnimator.flip()
    }
}
