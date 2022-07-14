//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class CountableEventsListView: UIView {
    // MARK: I18n
    static let empty = NSLocalizedString("empty.countableEventsList", comment: "entries list empty")
    static let firstCountableEventHappeningDescription = NSLocalizedString("empty.countableEventsList.firstCountableEventHappeningDescription", comment: "entries list first point")
    static let firstDetails = NSLocalizedString("empty.countableEventsList.firstDetailsInspection", comment: "entries list first details opening")

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
        view.register(CountableEventCell.self, forCellReuseIdentifier: CountableEventCell.reuseIdentifier)
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

    private lazy var firstCountableEventHappeningDescriptionLabel: UILabel = {
        let label = UILabel(al: true)
        label.text = Self.firstCountableEventHappeningDescription
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

    private lazy var inspectCountableEventLabel: UILabel = {
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

    lazy var cellGestureView: SwipeGestureView = {
        let view = SwipeGestureView(mode: SwipeGestureView.Mode.horizontal, edgeInset: .r2 + UIHelper.spacingListHorizontal)
        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.bottomAnchor.constraint(equalTo: viewTable.bottomAnchor),
            view.heightAnchor.constraint(equalToConstant: CountableEventCell.height),
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
        cellGestureView.isHidden = false
        firstCountableEventHappeningDescriptionLabel.isHidden = true
        inspectCountableEventLabel.isHidden = true
        addAndConstrain(input)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension CountableEventsListView {
    func showEmptyState() {
        emptyLabel.isHidden = false
    }

    func showFirstCountableEventHappeningDescriptionState() {
        firstCountableEventHappeningDescriptionLabel.isHidden = false
        cellGestureView.isHidden = false
    }

    func showFirstDetails() {
        inspectCountableEventLabel.isHidden = false
    }

    func hideAllHints() {
        inspectCountableEventLabel.isHidden = true
        firstCountableEventHappeningDescriptionLabel.isHidden = true
        cellGestureView.isHidden = true
        emptyLabel.isHidden = true
    }
}

// MARK: - Private
extension CountableEventsListView {
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
