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

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true

        view.register(DayOfTheWeekCell.self, forCellWithReuseIdentifier: DayOfTheWeekCell.reuseIdentifier)

        view.backgroundColor = .systemBackground

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
                label.widthAnchor.constraint(equalToConstant: .wScreen / 7),
            ])
        }

        return view
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension WeekView {
    private func setupLayout() {
        addSubview(collection)
        addSubview(weekdaysLine)

        NSLayoutConstraint.activate([
            collection.heightAnchor.constraint(equalToConstant: .hScreen / 3),
            
            collection.topAnchor.constraint(equalTo: topAnchor, constant: .sm),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor),

            weekdaysLine.topAnchor.constraint(equalTo: collection.bottomAnchor),
            weekdaysLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdaysLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdaysLine.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
