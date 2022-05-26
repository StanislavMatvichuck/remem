//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//
import CoreData.NSFetchedResultsController
import UIKit

class EntryDetailsController: UIViewController {
    // MARK: - Properties
    var entry: Entry!

    let clockController = ClockController()
    let pointsListController = PointsListController()
    let beltController = BeltController()
    let weekController = WeekController()

    // MARK: - View lifecycle
    private let viewRoot = EntryDetailsView()
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        title = entry.name

        setupClock()
        setupPointsList()
        setupBelt()
        setupWeek()
    }
}

// MARK: - Private
extension EntryDetailsController {
    private func setupClock() {
        contain(controller: clockController, in: viewRoot.clock)
    }

    private func setupPointsList() {
        contain(controller: pointsListController, in: viewRoot.pointsList)
    }

    private func setupBelt() {
        beltController.entry = entry
        contain(controller: beltController, in: viewRoot.belt)
    }

    private func setupWeek() {
        weekController.entry = entry
        contain(controller: weekController, in: viewRoot.week)
        weekController.delegate = clockController
    }

    private func contain(controller: UIViewController, in view: UIView) {
        addChild(controller)
        view.addAndConstrain(controller.view)
        controller.didMove(toParent: self)
    }
}
