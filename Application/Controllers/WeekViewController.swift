//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain

import UIKit

class WeekViewController: UIViewController {
    // MARK: - Properties
    var scrollHappened = false

    let today: DayComponents
    var event: Event
    let useCase: EventEditUseCasing
    let coordinator: Coordinating
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
        viewRoot.collection.scrollToItem(
            at: IndexPath(row: viewModel.scrollToIndex, section: 0),
            at: .left,
            animated: false)
    }
}

// MARK: - EditUseCaseDelegating
extension WeekViewController: EventEditUseCasingDelegate {
    func update(event: Domain.Event) {
        self.event = event
        viewModel = WeekViewModel(today: today, event: event)
        viewRoot.collection.reloadData()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension WeekViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int
    {
        viewModel.items.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: WeekItem.reuseIdentifier,
                for: indexPath) as? WeekItem
        else { fatalError("cell type") }
        cell.viewModel = viewModel.items[indexPath.row]
        return cell
    }

    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vm = viewModel.items[indexPath.row]

        coordinator.show(DayViewController(
            day: vm.day,
            event: event,
            useCase: useCase)
        )
    }

    // UICollectionViewDelegateFlowLayout
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        CGSize(
            width: collectionView.bounds.width / 7,
            height: collectionView.bounds.height)
    }
}
