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

    private lazy var firstPointLabel: UILabel = {
        let label = UILabel(al: true)
        label.text = Self.firstPoint
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

    private lazy var inspectEntryLabel: UILabel = {
        let label = UILabel(al: true)
        label.text = Self.firstDetails
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
        let view = SwipeGestureView(mode: SwipeGestureView.Mode.vertical, edgeInset: 40)
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
        let view = SwipeGestureView(mode: SwipeGestureView.Mode.horizontal, edgeInset: .sm + .r2)
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
        backgroundColor = .secondarySystemBackground
//        let image = UIImage(named: "plus")?.withTintColor(.systemBackground.withAlphaComponent(0.5))
//        let resizedImage = image?.scalePreservingAspectRatio(targetSize: CGSize(width: 80, height: 80))
//        let bg = UIImageView(image: resizedImage?.resizableImage(withCapInsets: .zero, resizingMode: .tile))
//        bg.translatesAutoresizingMaskIntoConstraints = false
//        addAndConstrain(bg)
        setupSwiper()
        setupTableView()
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

// MARK: - Private
extension EntriesListView {
    private func setupSwiper() {
        addSubview(swiper)
        NSLayoutConstraint.activate([
            swiper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.delta1),
            swiper.leadingAnchor.constraint(equalTo: leadingAnchor),
            swiper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.sm),
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

    func showFirstPointState() {
        firstPointLabel.isHidden = false
        cellGestureView.isHidden = false
    }

    func hideFirstPointState() {
        firstPointLabel.isHidden = true
        cellGestureView.isHidden = true
    }

    func showFirstDetails() {
        inspectEntryLabel.isHidden = false
    }

    func hideFirstDetails() {
        inspectEntryLabel.isHidden = true
    }
}
