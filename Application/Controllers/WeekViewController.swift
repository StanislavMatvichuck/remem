//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import UIKit

class WeekViewController: UIViewController {
    var scrollHappened = false
    var viewModel: WeekViewModel {
        didSet {
            viewRoot.collection.reloadData()
            updateSummary()
        }
    }

    let viewRoot: WeekView

    init(viewModel: WeekViewModel) {
        self.viewModel = viewModel
        self.viewRoot = WeekView()

        super.init(nibName: nil, bundle: nil)

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
        viewRoot.collection.layoutIfNeeded()
        viewRoot.collection.scrollToItem(
            at: IndexPath(row: viewModel.scrollToIndex, section: 0),
            at: .left,
            animated: false)
        // viewRoot.summary may also be updated here but contentOffset is required
        print("setInitialScrollPosition offset \(viewRoot.collection.contentOffset.x)")
        updateSummary()
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
        viewModel.timeline.count
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
        cell.viewModel = viewModel.timeline[indexPath.row]
        return cell
    }

    // UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.animateTapReceiving()
        viewModel.timeline[indexPath.row]?.select()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateSummary()
    }

    private func makeWeekIndexForCurrentPosition() -> Int {
        let offset = viewRoot.collection.contentOffset.x

        guard offset != 0 else { return 0 }

        let collectionWidth = viewRoot.collection.bounds.width
        return Int(offset / collectionWidth)
    }

    private func updateSummary() {
        let summaryValue = String(viewModel.summaryTimeline[makeWeekIndexForCurrentPosition()] ?? 0)
        viewRoot.summary.text = summaryValue
    }
}
