//
//  ViewPointsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EntryDetailsView: UIView {
    //

    // MARK: - Public properties

    //

    let viewPointsDisplay: UITableView = {
        let view = UITableView(al: true)

        view.register(PointTimeCell.self, forCellReuseIdentifier: PointTimeCell.reuseIdentifier)
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = .delta1

        view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: .delta1, height: .delta1 / 2))
        view.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: .delta1, height: .delta1 / 2))
        view.scrollIndicatorInsets = UIEdgeInsets(top: .delta1, left: 0, bottom: .delta1, right: .delta1 / 2)
        view.allowsSelection = false
        view.separatorStyle = .none

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

        view.viewContent.spacing = .delta1
        // to place elements in the center of screen
        view.viewContent.layoutMargins = UIEdgeInsets(top: 0, left: .delta1,
                                                      bottom: 0, right: .delta1)
        view.viewContent.isLayoutMarginsRelativeArrangement = true

        // to fix vertical scrolling on x3 scale displays
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0)
        return view
    }()

    //

    // MARK: - Private properties

    //

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(viewPointsDisplay)
        addSubview(viewStatsDisplay)
        addSubview(viewWeekDisplay)
        addSubview(viewWeekdaysLine)

        NSLayoutConstraint.activate([
            viewPointsDisplay.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .delta1),
            viewPointsDisplay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .delta1),
            viewPointsDisplay.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.delta1),

            viewStatsDisplay.topAnchor.constraint(equalTo: viewPointsDisplay.bottomAnchor, constant: .delta1),
            viewStatsDisplay.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewStatsDisplay.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewWeekDisplay.topAnchor.constraint(equalTo: viewStatsDisplay.bottomAnchor, constant: .delta1),
            viewWeekDisplay.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewWeekDisplay.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewWeekDisplay.heightAnchor.constraint(equalToConstant: 5 * .wScreen / 7),

            viewWeekdaysLine.topAnchor.constraint(equalTo: viewWeekDisplay.bottomAnchor),
            viewWeekdaysLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewWeekdaysLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewWeekdaysLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    //

    // MARK: - Behaviour

    //
    func showEmptyState() {}
    func hideEmptyState() {}
}
