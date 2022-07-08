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

    private let clockService: ClockService
    private var freshPoint: Point?

    private var clocksAnimator: ClockAnimator?
    private var clocksPainterTimer: Timer?

    private var sectionsListDay: ClockSectionsList
    private var sectionsListNight: ClockSectionsList

    private var sectionsAnimatorDay: ClockSectionsAnimator?
    private var sectionsAnimatorNight: ClockSectionsAnimator?

    // MARK: - Init
    init(service: ClockService, freshPoint: Point?) {
        sectionsListDay = .makeForDayClock(freshPoint: freshPoint)
        sectionsListNight = .makeForNightClock(freshPoint: freshPoint)
        clockService = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

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
//        ClockPainter.drawsSections = true
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
        redraw()
    }

    private func animateSections() {
        sectionsAnimatorDay?.update(newList: sectionsListDay)
        sectionsAnimatorNight?.update(newList: sectionsListNight)
    }

    private func updateLists(from: Date, to: Date) {
        let points = clockService.fetch(from: from, to: to)

        sectionsListDay.fill(with: points)
        sectionsListNight.fill(with: points)
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
