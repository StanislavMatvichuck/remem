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
    private let shownDaysForward = 14

    // MARK: - Init
    init(model: Model) {
        self.model = model

        let start = model.dateCreated.startOfWeek!
        let futureDays = Double(60*60*24*shownDaysForward)
        let end = Date.now.endOfWeek!.addingTimeInterval(futureDays)

        happeningsList = WeekList(from: start, to: end, event: model)
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

    func day(for cell: WeekCell) -> DateComponents? {
        guard let index = view?.collection.indexPath(for: cell) else { return nil }
        let calendar = Calendar.current
        let cellDate = happeningsList.days[index.row].date
        let components = calendar.dateComponents([.year, .month, .day], from: cellDate)
        return components
    }
}

// MARK: - UICollectionViewDataSource
extension WeekViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return happeningsList.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.reuseIdentifier, for: indexPath)
            as? WeekCell
        else { return UICollectionViewCell() }

        let weekDay = happeningsList.days[indexPath.row]
        let weekCellViewModel = WeekCellViewModel(model: weekDay)
        weekCellViewModel.configure(cell)

        return cell
    }
}

// MARK: - Private
extension WeekViewModel {
    private func setInitialScrollPosition() {
        let lastCellIndex = IndexPath(row: happeningsList.days.count - 1, section: 0)
        let scrollToIndex = IndexPath(row: lastCellIndex.row - shownDaysForward, section: 0)
        view?.collection.scrollToItem(at: scrollToIndex, at: .right, animated: false)
    }
}
