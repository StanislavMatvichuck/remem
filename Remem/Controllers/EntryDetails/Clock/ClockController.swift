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

        guard let start = Date.now.startOfWeek, let end = Date.now.endOfWeek else { return }
        clockService.fetch(from: start, to: end)
        viewRoot.clockDay.sectionsList = clockService.daySectionsList
        viewRoot.clockNight.sectionsList = clockService.nightSectionsList

        addTapHanders()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewRoot.clockDay.clockFace.animatedPainter = ClockAnimatedPainter(
            clockFace: viewRoot.clockDay.clockFace,
            descriptionsList: viewRoot.clockDay.sectionsList)
    }
}

// MARK: - User input
extension ClockController {
    private func addTapHanders() {
        viewRoot.clockDay.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleClockPress)))
        viewRoot.clockNight.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleClockPress)))
    }

    @objc private func handleClockPress() {
        clockAnimator.flip()
    }
}

extension ClockController: WeekControllerDelegate {
    func weekControllerNewWeek(from: Date, to: Date) {
        clockService.fetch(from: from, to: to)
        viewRoot.clockDay.clockFace.animatedPainter?.update()
    }
}
