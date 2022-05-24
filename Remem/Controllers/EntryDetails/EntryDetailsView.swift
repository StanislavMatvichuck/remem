//
//  ViewPointsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EntryDetailsView: UIView {
    // MARK: - Properties

    let viewWeekDisplay: UICollectionView = {
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

    let viewWeekdaysLine: UIStackView = {
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
            label.font = .systemFont(ofSize: .font1)
            label.textColor = .tertiaryLabel

            view.addArrangedSubview(label)

            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalToConstant: .wScreen / 7),
            ])
        }

        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: .wScreen / 7),
        ])

        return view
    }()

    let timeContainer: ViewScroll = {
        let view = ViewScroll(.horizontal)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    let pointsListContainer = UIView(al: true)
    let beltContainer = UIView(al: true)
    let clockContainer = UIView(al: true)

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        timeContainer.contain(views: clockContainer, pointsListContainer)

        addSubview(timeContainer)
        addSubview(beltContainer)
        addSubview(viewWeekDisplay)
        addSubview(viewWeekdaysLine)

        NSLayoutConstraint.activate([
            clockContainer.widthAnchor.constraint(equalTo: widthAnchor),
            pointsListContainer.widthAnchor.constraint(equalTo: widthAnchor),

            timeContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .sm),
            timeContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            beltContainer.topAnchor.constraint(equalTo: timeContainer.bottomAnchor, constant: .sm),
            beltContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            beltContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewWeekDisplay.topAnchor.constraint(equalTo: beltContainer.bottomAnchor, constant: .sm),
            viewWeekDisplay.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewWeekDisplay.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewWeekDisplay.heightAnchor.constraint(equalToConstant: 5 * .wScreen / 7),

            viewWeekdaysLine.topAnchor.constraint(equalTo: viewWeekDisplay.bottomAnchor),
            viewWeekdaysLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewWeekdaysLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewWeekdaysLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
