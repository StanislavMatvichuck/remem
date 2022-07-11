//
//  ClockController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class ClockController: UIViewController {
    

    // MARK: - Properties
    private let viewRoot = ClockView()
    private let clockService: ClockService

    // MARK: - Init
    init(service: ClockService, freshPoint: Point?) {
        clockService = service

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() { addTapHanders() }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLists()
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
        viewRoot.animator.flip(dayClock: viewRoot.clockDay, nightClock: viewRoot.clockNight)
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

    private func updateLists(from: Date, to: Date) {
        let points = clockService.fetch(from: from, to: to)

        viewRoot.clockNight.clockFace.sectionsAnimator.show(points)
        viewRoot.clockDay.clockFace.sectionsAnimator.show(points)
    }
}

// MARK: - WeekControllerDelegate
extension ClockController: WeekControllerDelegate {
    func weekControllerNewWeek(from: Date, to: Date) {
        updateLists(from: from, to: to)
    }
}
