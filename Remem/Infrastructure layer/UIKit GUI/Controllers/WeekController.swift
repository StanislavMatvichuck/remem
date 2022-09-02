//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class WeekController: UIViewController {
    // MARK: - Properties
    private var scrollHappened = false

    private let viewRoot: WeekView
    private let viewModel: WeekViewModelInput
    private let factory: WeekFactoryInterface
    // MARK: - Init
    init(viewRoot: WeekView, viewModel: WeekViewModelInput, factory: WeekFactoryInterface) {
        self.viewRoot = viewRoot
        self.viewModel = viewModel
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        viewRoot.collection.dataSource = self
        viewRoot.collection.delegate = self
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRoot.collection.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollToCurrentWeek()
    }

    private func scrollToCurrentWeek() {
        guard !scrollHappened else { return }
        setInitialScrollPosition()
        scrollHappened = true
    }

    private func setInitialScrollPosition() {
        let lastCellIndex = IndexPath(row: viewModel.happeningsList.days.count - 1, section: 0)
        let scrollToIndex = IndexPath(row: lastCellIndex.row - viewModel.shownDaysForward, section: 0)
        viewRoot.collection.scrollToItem(at: scrollToIndex, at: .right, animated: false)
    }

    func day(for cell: WeekCell) -> DateComponents? {
        guard let index = viewRoot.collection.indexPath(for: cell) else { return nil }
        let calendar = Calendar.current
        let cellDate = viewModel.happeningsList.days[index.row].date
        let components = calendar.dateComponents([.year, .month, .day], from: cellDate)
        return components
    }
}

// MARK: - UICollectionViewDataSource
extension WeekController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.happeningsList.days.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.reuseIdentifier, for: indexPath)
            as? WeekCell
        else { return UICollectionViewCell() }

        let day = viewModel.happeningsList.days[indexPath.row]
        let viewModel = factory.makeWeekCellViewModel(weekDay: day)
        cell.viewModel = viewModel
        viewModel.delegate = cell

        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension WeekController:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width / 7,
                      height: collectionView.bounds.height)
    }
}

// MARK: - WeekCellDelegate
extension WeekController: WeekCellDelegate {
    func didPress(cell: WeekCell) {
        guard let day = day(for: cell) else { return }
        viewModel.select(day: day)
    }
}

// MARK: - WeekViewModelOutput
extension WeekController: WeekViewModelOutput {
    func animate(at: IndexPath) {
        // GOAL ADDED
    }

    func update() {
        viewRoot.collection.reloadData()
    }
}
