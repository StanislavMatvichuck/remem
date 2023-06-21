//
//  WeekView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

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

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public behaviour
    func configure(_ vm: WeekViewModel) {
        collection.reloadData()
        configureSummary(vm)
        scrollTo = IndexPath(row: vm.timelineVisibleIndex, section: 0)
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

    var dayCellVerticalDistanceToBottom: CGFloat { collection.frame.maxY - collectionAndCellVerticalDifference / 2 }
    var dayCellDefaultFrameY: CGFloat { collectionAndCellVerticalDifference / 2 }

    private var collectionAndCellVerticalDifference: CGFloat { collection.bounds.height - WeekCell.layoutSize.height }

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

    override func layoutSubviews() {
        super.layoutSubviews()

        collection.layoutIfNeeded()
        if let scrollTo {
            collection.scrollToItem(at: scrollTo, at: .left, animated: false)
        }
    }
}
