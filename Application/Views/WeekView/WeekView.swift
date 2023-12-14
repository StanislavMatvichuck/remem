//
//  WeekView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import UIKit

final class WeekView: UIView {
    let goal = WeekSummaryView()
    let weekdays = WeekdaysView()
    var scrollTo: IndexPath?

    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.itemSize = WeekCell.layoutSize

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        view.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -3, right: 0)
        view.register(WeekCell.self, forCellWithReuseIdentifier: WeekCell.reuseIdentifier)
        return view
    }()

    var dayCellVerticalDistanceToBottom: CGFloat { collection.frame.maxY - collectionAndCellVerticalDifference / 2 }
    var dayCellDefaultFrameY: CGFloat { collectionAndCellVerticalDifference / 2 }
    var collectionAndCellVerticalDifference: CGFloat { collection.bounds.height - WeekCell.layoutSize.height }

    var viewModel: WeekViewModel { didSet { configure(viewModel) }}

    init(_ viewModel: WeekViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()

        collection.layoutIfNeeded()
        if let scrollTo {
            collection.scrollToItem(at: scrollTo, at: .left, animated: false)
        }
    }

    // MARK: - Public behaviour
    func configure(_ viewModel: WeekViewModel) {
        collection.reloadData()
        configureSummary(viewModel)
        scrollTo = IndexPath(row: viewModel.timelineVisibleIndex, section: 0)
    }

    func configureSummary(_ vm: WeekViewModel) {
        guard let page = vm.pages[vm.pagesVisibleIndex] else { return }
        goal.configure(page)
    }

    func resizeGoalInputAndRedrawAccessory() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.goal.invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Private
    private func configureLayout() {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.alignment = .center
        stack.addArrangedSubview(goal)
        stack.addArrangedSubview(collection)
        stack.addArrangedSubview(weekdays)

        addAndConstrain(stack)

        NSLayoutConstraint.activate([
            collection.heightAnchor.constraint(equalToConstant: WeekCell.layoutSize.height + .buttonMargin + 3),
            collection.widthAnchor.constraint(equalTo: widthAnchor),
            goal.widthAnchor.constraint(equalToConstant: .layoutSquare * 7),
        ])
    }

    private func configureAppearance() {
        clipsToBounds = true
        backgroundColor = .clear
    }

    private func prepareForAnimation(_ view: UIView) {
        view.frame.origin.y = dayCellVerticalDistanceToBottom
        view.transform = .init(scaleX: 0.8, y: 1)
    }
}

// MARK: - UICollectionViewDataSource
extension WeekView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.timelineCount }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: WeekCell.reuseIdentifier,
            for: indexPath) as? WeekCell
        else { fatalError("cell type") }

        cell.viewModel = viewModel.weekCellFactory.makeViewModel(indexPath: indexPath, cellPresentationAnimationBlock: {}, cellDismissAnimationBlock: {})

        if let animatedIndex = viewModel.timelineAnimatedCellIndex, animatedIndex == indexPath.row {
            cell.frame.origin.y = -dayCellVerticalDistanceToBottom
        }

        return cell
    }
}
