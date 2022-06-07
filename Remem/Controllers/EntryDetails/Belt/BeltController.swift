//
//  BeltController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

protocol BeltControllerDelegate {
    func didPressAddToLockScreen()
    func didPressRemoveFromLockScreen()
}

class BeltController: UIViewController {
    // MARK: I18n
    static let dayAverage = NSLocalizedString("label.stats.average.day", comment: "EntryDetailsScreen")
    static let weekAverage = NSLocalizedString("label.stats.average.week", comment: "EntryDetailsScreen")
    static let lastWeekTotal = NSLocalizedString("label.stats.weekLast.total", comment: "EntryDetailsScreen")
    static let thisWeekTotal = NSLocalizedString("label.stats.weekThis.total", comment: "EntryDetailsScreen")

    // MARK: - Properties
    var entry: Entry!
    var delegate: BeltControllerDelegate?

    private let viewRoot = BeltView()
    private var scrollHappened = false
    private var viewButtonLockScreen: UIView?
    private var shouldRemoveFromLockScreen = false

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setup()

        viewButtonLockScreen?.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handlePressLockScreen))
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollOnce()
    }
}

// MARK: - Private
extension BeltController {
    @objc private func handlePressLockScreen() {
        if shouldRemoveFromLockScreen {
            delegate?.didPressRemoveFromLockScreen()
        } else {
            delegate?.didPressAddToLockScreen()
        }
    }

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
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        let dayAverage = formatter.string(from: entry.dayAverage as NSNumber)
        let weekAverage = formatter.string(from: entry.weekAverage as NSNumber)
        let lastWeekTotal = formatter.string(from: entry.lastWeekTotal as NSNumber)
        let thisWeekTotal = formatter.string(from: entry.thisWeekTotal as NSNumber)

        let viewDayAverage = ViewStatDisplay(title: dayAverage, description: Self.dayAverage)
        let viewWeekAverage = ViewStatDisplay(title: weekAverage, description: Self.weekAverage)
        let viewLastWeekTotal = ViewStatDisplay(title: lastWeekTotal, description: Self.lastWeekTotal)
        let viewThisWeekTotal = ViewStatDisplay(title: thisWeekTotal, description: Self.thisWeekTotal)

        let image = UIImage(systemName: "iphone")?
            .withTintColor(UIHelper.brandDimmed)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))

        viewButtonLockScreen = ViewStatDisplay(image: image, description: "Add to lock screen")

        viewRoot.scroll.contain(views:
            viewDayAverage,
            viewWeekAverage,
            viewThisWeekTotal,
            viewLastWeekTotal,
            viewButtonLockScreen!)
    }
}

// MARK: - TODO: remove this mess
extension BeltController {
    func installAddToLockScreenButton() {
        guard let button = viewButtonLockScreen as? ViewStatDisplay else { return }
        shouldRemoveFromLockScreen = false
        button.update(color: UIHelper.brandDimmed)
        button.updateImage(color: UIHelper.itemFont)
        button.update(description: "Add to lock screen")
    }

    func installRemoveFromLockScreenButton() {
        guard let button = viewButtonLockScreen as? ViewStatDisplay else { return }
        shouldRemoveFromLockScreen = true
        button.update(color: UIHelper.itemFont)
        button.updateImage(color: UIHelper.brandDimmed)
        button.update(description: "Remove from lock screen")
    }
}
