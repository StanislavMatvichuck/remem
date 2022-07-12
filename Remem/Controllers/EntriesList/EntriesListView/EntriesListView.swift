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
    static let firstPoint = NSLocalizedString("empty.entriesList.firstPoint", comment: "entries list first point")
    static let firstDetails = NSLocalizedString("empty.entriesList.firstDetailsInspection", comment: "entries list first details opening")

    // MARK: - Properties
    lazy var buttonAdd: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = .r2

        let label = UILabel(al: true)
        label.text = "+"
        label.textAlignment = .center
        label.textColor = .white

        view.addAndConstrain(label)

        return view
    }()

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
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont
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

    private lazy var firstPointLabel: UILabel = {
        let label = UILabel(al: true)
        label.text = Self.firstPoint
        label.textAlignment = .center
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont
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

    private lazy var inspectEntryLabel: UILabel = {
        let label = UILabel(al: true)
        label.text = Self.firstDetails
        label.textAlignment = .center
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont
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
        let view = SwipeGestureView(mode: SwipeGestureView.Mode.vertical, edgeInset: 0)
        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: .hScreen / 3),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        return view
    }()

    lazy var cellGestureView: SwipeGestureView = {
        let view = SwipeGestureView(mode: SwipeGestureView.Mode.horizontal, edgeInset: .r2 + UIHelper.spacingListHorizontal)
        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: EntryCell.height),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        return view
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = UIHelper.background
        setupLayout()
        // these flags configure UIView tree
        emptyLabel.isHidden = false
        gestureView.isHidden = false
        cellGestureView.isHidden = false
        firstPointLabel.isHidden = true
        inspectEntryLabel.isHidden = true
        addAndConstrain(input)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension EntriesListView {
    func showEmptyState() {
        emptyLabel.isHidden = false
        gestureView.isHidden = false
    }

    func showFirstPointState() {
        firstPointLabel.isHidden = false
        cellGestureView.isHidden = false
    }

    func showFirstDetails() {
        inspectEntryLabel.isHidden = false
    }

    func hideAllHints() {
        inspectEntryLabel.isHidden = true
        firstPointLabel.isHidden = true
        cellGestureView.isHidden = true
        emptyLabel.isHidden = true
        gestureView.isHidden = true
    }
}

// MARK: - Private
extension EntriesListView {
    private func setupLayout() {
        addSubview(buttonAdd)
        addSubview(viewTable)

        NSLayoutConstraint.activate([
            buttonAdd.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIHelper.spacingListHorizontal),
            buttonAdd.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -UIHelper.spacingListHorizontal),

            buttonAdd.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            buttonAdd.heightAnchor.constraint(equalToConstant: .d2),

            viewTable.topAnchor.constraint(equalTo: topAnchor),
            viewTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewTable.bottomAnchor.constraint(equalTo: buttonAdd.topAnchor),
        ])
    }
}
