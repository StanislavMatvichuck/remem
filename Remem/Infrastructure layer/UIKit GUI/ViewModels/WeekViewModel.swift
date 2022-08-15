//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import UIKit

class WeekViewModel: NSObject {
    typealias View = WeekView
    typealias Model = Event

    // MARK: - Properties
    private let model: Model
    private weak var view: View?
    private var scrollHappened = false
    private let happeningsList: WeekList

    // MARK: - Init
    init(model: Model) {
        self.model = model

        let start = model.dateCreated.startOfWeek!
        let end = Date.now.endOfWeek!

        happeningsList = WeekList(from: start, to: end, happenings: model.happenings)
    }
}

// MARK: - Public
extension WeekViewModel {
    func configure(_ view: View) {
        self.view = view

        view.collection.dataSource = self
        view.collection.reloadData()
    }

    func scrollToCurrentWeek() {
        guard !scrollHappened else { return }
        setInitialScrollPosition()
        scrollHappened = true
    }

    func day(for cell: DayOfTheWeekCell) -> DateComponents? {
        guard let index = view?.collection.indexPath(for: cell) else { return nil }
        return happeningsList.days[index.row].date
    }
}

// MARK: - UICollectionViewDataSource
extension WeekViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return happeningsList.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayOfTheWeekCell.reuseIdentifier, for: indexPath)
            as? DayOfTheWeekCell
        else { return UICollectionViewCell() }

        let weekDay = happeningsList.days[indexPath.row]

        cell.day.text = String(weekDay.dayNumber)
        cell.day.textColor = weekDay.isToday ? UIHelper.brand : UIHelper.itemFont

        let amount = weekDay.amount

        if amount == 0 {
            cell.amount.text = " "
        } else {
            cell.amount.text = String(amount)

            if let date = Calendar.current.date(from: weekDay.date) {
                let happeningsForDay = model.happenings(forDay: date)
                cell.showSections(amount: amount, happenings: happeningsForDay)
            }
        }

        return cell
    }
}

// MARK: - Private
extension WeekViewModel {
    private func setInitialScrollPosition() {
        let lastCellIndex = IndexPath(row: happeningsList.days.count - 1, section: 0)
        view?.collection.scrollToItem(at: lastCellIndex, at: .right, animated: false)
    }
}
