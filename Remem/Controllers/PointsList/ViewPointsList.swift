//
//  ViewPointsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class ViewPointsList: UIView {
    //

    // MARK: - Public properties

    //

    let viewTable: UITableView = {
        let view = UITableView(frame: .zero)

        view.register(CellPoint.self, forCellReuseIdentifier: CellPoint.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground

        view.tableFooterView = UIView()
        view.allowsSelection = false
        view.separatorStyle = .none

        return view
    }()

    let viewDisplay: UICollectionView = {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true

        view.register(CellDay.self, forCellWithReuseIdentifier: CellDay.reuseIdentifier)

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

    let viewStats: ViewScroll = {
        let view = ViewScroll(.horizontal)

        view.isPagingEnabled = true

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
        addSubview(viewTable)
        addSubview(viewStats)
        addSubview(viewDisplay)
        addSubview(viewWeekdaysLine)

        NSLayoutConstraint.activate([
            viewTable.topAnchor.constraint(equalTo: topAnchor),
            viewTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewTable.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewDisplay.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewDisplay.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewStats.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewStats.trailingAnchor.constraint(equalTo: trailingAnchor),

            viewStats.topAnchor.constraint(equalTo: viewTable.bottomAnchor),
            viewStats.bottomAnchor.constraint(equalTo: viewDisplay.topAnchor),

            viewWeekdaysLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewWeekdaysLine.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewWeekdaysLine.topAnchor.constraint(equalTo: viewDisplay.bottomAnchor),
            viewWeekdaysLine.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            viewDisplay.heightAnchor.constraint(equalToConstant: 5 * .wScreen / 7),
        ])
    }

    //

    // MARK: - Behaviour

    //
    func showEmptyState() {}
    func hideEmptyState() {}
}
