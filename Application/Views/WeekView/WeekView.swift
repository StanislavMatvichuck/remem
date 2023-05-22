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

    private var scrollHappened = false

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
    }

    func configureSummary(_ vm: WeekViewModel) {
        let index = weekIndexForCurrentScrollPosition()
        guard let page = vm.newPages[index] else { return }
        goal.configure(page)
        resizeGoalInputAndRedrawAccessory()
    }

    func resizeGoalInputAndRedrawAccessory() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.goal.invalidateIntrinsicContentSize()
        }
    }

    func scrollToCurrentWeek(_ vm: WeekViewModel) {
        guard !scrollHappened else { return }
        setInitialScrollPosition(vm)
        scrollHappened = true
    }

    // MARK: - Private
    private func weekIndexForCurrentScrollPosition() -> Int {
        let collectionWidth = collection.bounds.width
        let offset = collection.contentOffset.x
        guard offset != 0 else { return 0 }
        return Int(offset / collectionWidth)
    }

    private func setInitialScrollPosition(_ vm: WeekViewModel) {
        collection.layoutIfNeeded()
        collection.scrollToItem(
            at: IndexPath(row: vm.scrollToIndex, section: 0),
            at: .left,
            animated: false
        )

        configureSummary(vm)
    }

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
}
