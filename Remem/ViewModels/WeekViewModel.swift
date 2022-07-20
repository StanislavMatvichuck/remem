//
//  WeekViewModel.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 20.07.2022.
//

import UIKit

class WeekViewModel: NSObject {
    typealias View = WeekView
    typealias Model = WeekList

    // MARK: - Properties
    private let model: Model
    private weak var view: View?
    private var scrollHappened = false

    // MARK: - Init
    init(model: Model) {
        self.model = model
    }
}

// MARK: - Public
extension WeekViewModel {
    func configure(_ view: View) {
        self.view = view

        view.collection.dataSource = self
        view.collection.delegate = self
    }

    func scrollToCurrentWeek() {
        guard !scrollHappened else { return }
        setInitialScrollPosition()
        scrollHappened = true
    }
}

// MARK: - UICollectionViewDataSource
extension WeekViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DayOfTheWeekCell.reuseIdentifier,
                for: indexPath)
            as? DayOfTheWeekCell
        else { return UICollectionViewCell() }

        let weekDay = model.days[indexPath.row]

        cell.configure(day: "\(weekDay.dayNumber)", isToday: weekDay.isToday)
        cell.configure(amount: weekDay.amount)

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension WeekViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: .wScreen / 7, height: collectionView.bounds.height)
    }
}

// MARK: - Private
extension WeekViewModel {
    private func setInitialScrollPosition() {
        let lastCellIndex = IndexPath(row: model.days.count - 1, section: 0)
        view?.collection.scrollToItem(at: lastCellIndex, at: .right, animated: false)
    }
}
