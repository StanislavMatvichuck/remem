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

        for i in 1 ... 4 {
            let viewStat: UIView = {
                let viewStat = UIView(frame: .zero)
                viewStat.translatesAutoresizingMaskIntoConstraints = false

                let viewStatContainer = UIView(frame: .zero)
                viewStatContainer.translatesAutoresizingMaskIntoConstraints = false
                viewStatContainer.backgroundColor = .secondarySystemBackground
                viewStatContainer.layer.cornerRadius = 10

                let labelAmount = UILabel(frame: .zero)

                labelAmount.translatesAutoresizingMaskIntoConstraints = false
                labelAmount.text = "1234"
                labelAmount.numberOfLines = 1
                labelAmount.font = UIFont.systemFont(ofSize: 32)
                labelAmount.setContentHuggingPriority(.defaultHigh, for: .vertical)

                let labelDescription = UILabel(frame: .zero)

                labelDescription.translatesAutoresizingMaskIntoConstraints = false
                labelDescription.text = "Day or week average"
                labelDescription.font = .systemFont(ofSize: 16)
                labelDescription.numberOfLines = 2
                labelDescription.setContentHuggingPriority(.defaultLow, for: .vertical)
                
                if i > 1 {
                    labelDescription.text! += " some additional text"
                }

                viewStatContainer.addSubview(labelAmount)
                viewStatContainer.addSubview(labelDescription)
                viewStat.addAndConstrain(viewStatContainer, constant: 10)

                NSLayoutConstraint.activate([
                    viewStat.widthAnchor.constraint(equalToConstant: .wScreen / 2),

                    labelAmount.leadingAnchor.constraint(equalTo: viewStatContainer.leadingAnchor, constant: 10),
                    labelAmount.trailingAnchor.constraint(equalTo: viewStatContainer.trailingAnchor, constant: -10),
                    labelDescription.leadingAnchor.constraint(equalTo: viewStatContainer.leadingAnchor, constant: 10),
                    labelDescription.trailingAnchor.constraint(equalTo: viewStatContainer.trailingAnchor, constant: -10),

                    labelAmount.topAnchor.constraint(equalTo: viewStatContainer.topAnchor, constant: 10),
                    labelAmount.bottomAnchor.constraint(equalTo: labelDescription.topAnchor),
                    labelDescription.bottomAnchor.constraint(equalTo: viewStatContainer.bottomAnchor, constant: -10),
                ])

                return viewStat
            }()

            view.contain(views: viewStat)
        }

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
