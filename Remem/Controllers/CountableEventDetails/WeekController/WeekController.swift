//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

protocol WeekControllerDelegate {
    func weekControllerNewWeek(from: Date, to: Date)
}

class WeekController: UIViewController {
    // MARK: - Properties
    var event: Event!
    var weekDistributionService: WeekService!
    var delegate: WeekControllerDelegate?

    private let viewRoot = WeekView()
    private var scrollHappened = false

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() { setupCollection() }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollOnce()
    }
}

// MARK: - Public
extension WeekController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let weekNumber = Int(scrollView.contentOffset.x / .wScreen)
        let weekOffset = event.weeksSince - 1 - weekNumber
        let dateStart = Date.now.days(ago: Int(weekOffset) * 7).startOfWeek!
        let dateEnd = dateStart.endOfWeek!
        delegate?.weekControllerNewWeek(from: dateStart, to: dateEnd)
    }
}

// MARK: - Private
extension WeekController {
    private func setupCollection() {
        viewRoot.collection.dataSource = self
        viewRoot.collection.delegate = self
    }

    private func scrollOnce() {
        guard !scrollHappened else { return }
        setInitialScrollPosition()
        scrollHappened = true
    }

    private func setInitialScrollPosition() {
        let lastCellIndex = IndexPath(row: weekDistributionService.daysAmount - 1, section: 0)
        viewRoot.collection.scrollToItem(at: lastCellIndex, at: .right, animated: false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension WeekController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: .wScreen / 7, height: collectionView.bounds.height)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDistributionService.daysAmount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DayOfTheWeekCell.reuseIdentifier,
            for: indexPath) as! DayOfTheWeekCell

        let numberInMonth = weekDistributionService.dayOfMonth(for: indexPath)
        let isToday = indexPath.row == weekDistributionService.todayIndexRow

        cell.configure(day: "\(numberInMonth!)", isToday: isToday)
        cell.configure(amount: weekDistributionService.happeningsAmount(for: indexPath))
        return cell
    }
}
