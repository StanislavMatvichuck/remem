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
    var freshPoint: Point?

    private var clocksAnimator: ClockAnimator?
    private var clocksPainterTimer: Timer?

    private var sectionsListDay: ClockSectionsList = .makeForDayClock()
    private var sectionsListNight: ClockSectionsList = .makeForNightClock()

    private var sectionsAnimatorDay: ClockSectionsAnimator?
    private var sectionsAnimatorNight: ClockSectionsAnimator?

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        clocksAnimator = ClockAnimator(dayClock: viewRoot.clockDay,
                                       nightClock: viewRoot.clockNight)

        setupLists()
        setupTickingTimer()
        addTapHanders()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        installAnimators()
        animateSections()
    }

    deinit {
        clocksPainterTimer?.invalidate()
        ClockPainter.drawsSections = true
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
        clocksAnimator?.flip()
    }
}

// MARK: - Private
extension ClockController {
    private func setupLists() {
        guard
            let start = Date.now.startOfWeek,
            let end = Date.now.endOfWeek
        else { return }

        updateLists(from: start, to: end)
    }

    private func installAnimators() {
        sectionsAnimatorDay = ClockSectionsAnimator(clockFace: viewRoot.clockDay.clockFace)
        sectionsAnimatorNight = ClockSectionsAnimator(clockFace: viewRoot.clockNight.clockFace)
        ClockPainter.drawsSections = false
        redraw()
    }

    private func animateSections() {
        sectionsAnimatorDay?.update(newList: sectionsListDay)
        sectionsAnimatorNight?.update(newList: sectionsListNight)
    }

    private func updateLists(from: Date, to: Date) {
        let points = clockService.fetch(from: from, to: to)

        sectionsListDay.fill(with: points, freshPoint: freshPoint)
        sectionsListNight.fill(with: points, freshPoint: freshPoint)
    }
}

// MARK: - WeekControllerDelegate
extension ClockController: WeekControllerDelegate {
    func weekControllerNewWeek(from: Date, to: Date) {
        updateLists(from: from, to: to)
        animateSections()
    }
}

// MARK: - Clock drawing
extension ClockController {
    private func setupTickingTimer() {
        let currentSeconds = Calendar.current.dateComponents([.second], from: Date.now).second ?? 0
        let secondAfterMinuteUpdates = Double(60 - currentSeconds)

        DispatchQueue.main.asyncAfter(deadline: .now() + secondAfterMinuteUpdates) {
            if self.clocksPainterTimer == nil {
                self.clocksPainterTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                                               target: self,
                                                               selector: #selector(self.redraw),
                                                               userInfo: nil,
                                                               repeats: true)
            }
        }
    }

    @objc func redraw() {
        viewRoot.clockDay.clockFace.setNeedsDisplay()
        viewRoot.clockNight.clockFace.setNeedsDisplay()
    }
}
