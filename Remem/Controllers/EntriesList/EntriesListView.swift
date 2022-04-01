//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class EntriesListView: UIView {
    //

    // MARK: - Public properties

    //

    let viewTable: UITableView = {
        let view = UITableView(frame: .zero)

        view.register(EntryCell.self, forCellReuseIdentifier: EntryCell.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .clear

        view.tableFooterView = UIView()
        view.allowsSelection = false
        view.separatorStyle = .none
        view.transform = CGAffineTransform(scaleX: 1, y: -1)
        view.showsVerticalScrollIndicator = false

        return view
    }()

    let viewInputBackground: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .systemBackground
        return view
    }()

    let viewInput: UIView = {
        let view = UIView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .secondarySystemBackground

        let input = UITextView()
        input.translatesAutoresizingMaskIntoConstraints = false

        input.font = .systemFont(ofSize: .font1)
        input.textAlignment = .center
        input.backgroundColor = .clear

        view.addSubview(input)
        view.layer.cornerRadius = .r2
        view.isOpaque = true

        let circle = UIView(frame: .zero)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = .r1
        circle.backgroundColor = .tertiarySystemBackground

        view.addSubview(circle)

        let valueLabel: UILabel = {
            let label = UILabel(frame: .zero)

            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: .font1)
            label.numberOfLines = 1
            label.textColor = .systemBlue
            label.text = "0"

            return label
        }()

        view.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .wScreen - 2 * .delta1),
            view.heightAnchor.constraint(equalToConstant: .d2),

            input.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            input.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            input.heightAnchor.constraint(equalToConstant: .d1),
            input.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * .d2),

            circle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .delta1),
            circle.widthAnchor.constraint(equalToConstant: .d1),
            circle.heightAnchor.constraint(equalToConstant: .d1),

            valueLabel.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -.r2),
            valueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        return view
    }()

    var input: UITextView {
        viewInput.subviews[0] as! UITextView
    }

    var swiper: UISwipingSelectorInterface = UISwipingSelector()

    lazy var inputContainerConstraint: NSLayoutConstraint = {
        viewInput.topAnchor.constraint(equalTo: bottomAnchor)
    }()

    //

    // MARK: - Private properties

    //

    private let emptyLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have no entries yet. Swipe up to create"
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 0

        return label
    }()

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .systemBackground

        addSubview(swiper)

        NSLayoutConstraint.activate([
            swiper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.delta1),
            swiper.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])

        addSubview(viewTable)

        NSLayoutConstraint.activate([
            viewTable.topAnchor.constraint(equalTo: topAnchor),
            viewTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            viewTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewTable.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])

        setupEmptyLabel()

        setupViewInput()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupEmptyLabel() {
        addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            emptyLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .hScreen / 2),
            emptyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupViewInput() {
        addSubview(viewInputBackground)
        addSubview(viewInput)

        viewInputBackground.alpha = 0.0
        viewInputBackground.isHidden = true

        NSLayoutConstraint.activate([
            viewInput.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .xs),
            inputContainerConstraint,
        ])
    }

    //

    // MARK: - Behaviour

    //

    func showEmptyState() {
        emptyLabel.isHidden = false
    }

    func hideEmptyState() {
        emptyLabel.isHidden = true
    }
}
