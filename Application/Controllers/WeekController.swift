//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import IosUseCases
import UIKit

class WeekController: UIViewController {
    // MARK: - Properties
    var scrollHappened = false

    let today: DayComponents
    var event: Event
    let useCase: EventEditUseCasing
    weak var coordinator: Coordinating?
    var viewModel: WeekViewModel
    let viewRoot: WeekView

    // MARK: - Init

    init(
        today: DayComponents,
        event: Event,
        useCase: EventEditUseCasing,
        coordinator: Coordinating)
    {
        self.today = today
        self.event = event
        self.useCase = useCase
        self.coordinator = coordinator
        self.viewModel = WeekViewModel(today: today, event: event)
        self.viewRoot = WeekView()

        super.init(nibName: nil, bundle: nil)
        useCase.add(delegate: self)

        configureCollection()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureCollection() {
        viewRoot.collection.dataSource = self
        viewRoot.collection.delegate = self
    }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() { super.viewDidLoad() }

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
//        let lastCellIndex = IndexPath(row: viewModel.count - 1, section: 0)
//        let scrollToIndex = IndexPath(row: lastCellIndex.row - WeekViewModel.shownDaysForward, section: 0)
//        viewRoot.collection.scrollToItem(at: scrollToIndex, at: .right, animated: false)
    }
}

// MARK: - EditUseCaseDelegating
extension WeekController: EventEditUseCasingDelegate {
    func update(event: Domain.Event) {
        self.event = event
        viewModel = WeekViewModel(today: today, event: event)
        viewRoot.collection.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WeekController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        viewModel.weekCellViewModels.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WeekCell.reuseIdentifier,
                for: indexPath) as? WeekCell
        else { fatalError("cell type") }
        cell.viewModel = viewModel.weekCellViewModels[indexPath.row]
        return cell
    }

    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = viewModel.weekCellViewModels[indexPath.row]
        coordinator?.showDay(event: event, date: vm.day.date)
    }

    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width / 7,
                      height: collectionView.bounds.height)
    }
}
