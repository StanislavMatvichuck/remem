//
//  ViewPointsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EntryDetailsView: UIView {
    // MARK: - Properties
    let viewPointsDisplay: UITableView = {
        let view = UITableView(al: true)
        view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: .sm, height: .sm / 2))
        view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: .sm, height: .sm / 2))
        view.register(PointTimeCell.self, forCellReuseIdentifier: PointTimeCell.reuseIdentifier)
        view.scrollIndicatorInsets = UIEdgeInsets(top: .sm, left: 0, bottom: .sm, right: .sm / 2)
        view.allowsSelection = false
        view.separatorStyle = .none

        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = .sm
        return view
    }()

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

    let viewStatsDisplay: ViewScroll = {
        let view = ViewScroll(.horizontal)

        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false

        view.viewContent.spacing = .sm
        // to place elements in the center of screen
        view.viewContent.layoutMargins = UIEdgeInsets(top: 0, left: .sm,
                                                      bottom: 0, right: .sm)
        view.viewContent.isLayoutMarginsRelativeArrangement = true

        // to fix vertical scrolling on x3 scale displays
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0)
        return view
    }()

    let timeContainer: ViewScroll = {
        let view = ViewScroll(.horizontal)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    let clock = Clock()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        let pointsDisplayContainer = UIView(al: true)
        pointsDisplayContainer.addAndConstrain(viewPointsDisplay, constant: .sm)
        timeContainer.contain(views: clock, pointsDisplayContainer)

        addSubview(timeContainer)
        addSubview(viewStatsDisplay)
        addSubview(viewWeekDisplay)
        addSubview(viewWeekdaysLine)

        NSLayoutConstraint.activate([
            clock.widthAnchor.constraint(equalTo: widthAnchor),
            pointsDisplayContainer.widthAnchor.constraint(equalTo: widthAnchor),

            timeContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .sm),
            timeContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            timeContainer.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewStatsDisplay.topAnchor.constraint(equalTo: timeContainer.bottomAnchor, constant: .sm),
            viewStatsDisplay.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewStatsDisplay.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewWeekDisplay.topAnchor.constraint(equalTo: viewStatsDisplay.bottomAnchor, constant: .sm),
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
