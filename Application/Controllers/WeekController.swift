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

    let viewRoot = WeekView()
    let useCase: EventEditUseCasing
    var viewModel: WeekViewModel
    var event: Event
    // MARK: - Init

    init(event: Event, useCase: EventEditUseCasing) {
        self.useCase = useCase
        self.event = event
        self.viewModel = WeekViewModel(event: event)

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
        viewModel = WeekViewModel(event: event)
        viewRoot.collection.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension WeekController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCell.reuseIdentifier, for: indexPath)
            as? WeekCell
        else { return UICollectionViewCell() }

        let viewModel = viewModel.cellViewModel(at: indexPath.row)
        cell.viewModel = viewModel
        viewModel?.delegate = cell

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
