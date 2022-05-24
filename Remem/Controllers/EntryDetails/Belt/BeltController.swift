//
//  BeltController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class BeltController: UIViewController {
    // MARK: I18n
    static let dayAverage = NSLocalizedString("label.stats.average.day", comment: "EntryDetailsScreen")
    static let weekAverage = NSLocalizedString("label.stats.average.week", comment: "EntryDetailsScreen")
    static let lastWeekTotal = NSLocalizedString("label.stats.weekLast.total", comment: "EntryDetailsScreen")
    static let thisWeekTotal = NSLocalizedString("label.stats.weekThis.total", comment: "EntryDetailsScreen")

    // MARK: - Properties
    var entry: Entry!

    private let viewRoot = BeltView()
    private var scrollHappened = false

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() { setup() }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollOnce()
    }
}

// MARK: - Private
extension BeltController {
    private func scrollOnce() {
        guard !scrollHappened else { return }
        setInitialScrollPosition()
        scrollHappened = true
    }

    private func setInitialScrollPosition() {
        let point = CGPoint(x: 2 * .wScreen, y: 0)
        viewRoot.scroll.setContentOffset(point, animated: false)
    }

    private func setup() {
        let viewDayAverage = ViewStatDisplay(value: entry.dayAverage as NSNumber, description: Self.dayAverage)
        let viewWeekAverage = ViewStatDisplay(value: entry.weekAverage as NSNumber, description: Self.weekAverage)
        let viewLastWeekTotal = ViewStatDisplay(value: entry.lastWeekTotal as NSNumber, description: Self.lastWeekTotal)
        let viewThisWeekTotal = ViewStatDisplay(value: entry.thisWeekTotal as NSNumber, description: Self.thisWeekTotal)

        viewRoot.scroll.contain(views:
            viewDayAverage,
            viewWeekAverage,
            viewThisWeekTotal,
            viewLastWeekTotal)
    }
}
