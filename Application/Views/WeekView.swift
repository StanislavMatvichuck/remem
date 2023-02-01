//
//  WeekView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class WeekView: UIView {
    // MARK: - Properties
    let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.itemSize = WeekItem.layoutSize

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        view.register(WeekItem.self, forCellWithReuseIdentifier: WeekItem.reuseIdentifier)
        view.horizontalScrollIndicatorInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: -UIHelper.delta1,
            right: 0
        )

        return view
    }()

    let weekdaysLine: UIStackView = {
        let view = UIStackView(frame: .zero)

        view.axis = .horizontal
        view.translatesAutoresizingMaskIntoConstraints = false

        let fmt = DateFormatter()

        var days = fmt.veryShortWeekdaySymbols!

        days = Array(days[1..<days.count]) + days[0..<1]

        for (index, day) in days.enumerated() {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = day
            label.textAlignment = .center
            label.font = UIHelper.fontSmallBold
            label.textColor = UIHelper.itemFont

            view.addArrangedSubview(label)

            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 7),
            ])
        }

        return view
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIHelper.background
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.addArrangedSubview(collection)
        stack.addArrangedSubview(weekdaysLine)
        addAndConstrain(stack)

        collection.heightAnchor.constraint(equalToConstant: WeekItem.layoutSize.height).isActive = true
    }
}
