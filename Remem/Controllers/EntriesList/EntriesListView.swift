//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EntriesListView: UIView {
    // MARK: I18n
    static let empty = NSLocalizedString("empty.entriesList", comment: "entries list empty")

    // MARK: - Properties
    let swiper: UISwipingSelectorInterface = UISwipingSelector()
    let input: UIMovableTextViewInterface = UIMovableTextView()

    let viewTable: UITableView = {
        let view = UITableView(al: true)
        view.register(EntryCell.self, forCellReuseIdentifier: EntryCell.reuseIdentifier)
        view.transform = CGAffineTransform(scaleX: 1, y: -1)
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.tableFooterView = UIView()
        view.backgroundColor = .clear
        view.allowsSelection = false
        view.separatorStyle = .none
        return view
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel(al: true)
        label.text = Self.empty
        label.textAlignment = .center
        label.font = .systemFont(ofSize: .font2, weight: .semibold)
        label.numberOfLines = 0
        addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: readableContentGuide.widthAnchor),
            label.centerXAnchor.constraint(equalTo: readableContentGuide.centerXAnchor),
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            label.heightAnchor.constraint(equalToConstant: .hScreen / 3),
        ])
        return label
    }()

    lazy var gestureView: SwipeGestureView = {
        let view = SwipeGestureView(mode: SwipeGestureView.Mode.vertical, edgeInset: 0.0)
        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: .hScreen / 3),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        return view
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .secondarySystemBackground
        setupSwiper()
        setupTableView()
        emptyLabel.isHidden = false
        gestureView.isHidden = false
        addAndConstrain(input)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension EntriesListView {
    private func setupSwiper() {
        addSubview(swiper)
        NSLayoutConstraint.activate([
            swiper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.delta1),
            swiper.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }

    private func setupTableView() {
        addSubview(viewTable)
        NSLayoutConstraint.activate([
            viewTable.topAnchor.constraint(equalTo: topAnchor),
            viewTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Public
extension EntriesListView {
    func showEmptyState() {
        emptyLabel.isHidden = false
        gestureView.isHidden = false
    }

    func hideEmptyState() {
        emptyLabel.isHidden = true
        gestureView.isHidden = true
    }
}
