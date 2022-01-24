//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class ViewMain: UIView {
    //

    // MARK: - Public properties

    //

    let viewTable: UITableView = {
        let view = UITableView(frame: .zero)

        view.register(CellMain.self, forCellReuseIdentifier: CellMain.reuseIdentifier)
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

    let viewSwiper: UIView = {
        let view = UIView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .secondarySystemBackground

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            view.heightAnchor.constraint(equalToConstant: 2 * .xs + CellMain.r2),
        ])

        let createPointView: UIView = {
            let view = UIView(frame: .zero)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .systemBlue
            view.layer.cornerRadius = CellMain.r2 / 2
            view.layer.opacity = 0.75

            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "point"
            label.textAlignment = .center
            label.textColor = .systemBackground
            
            view.addAndConstrain(label)

            return view
        }()

        view.addSubview(createPointView)

        let screenThird = UIScreen.main.bounds.width / 3

        NSLayoutConstraint.activate([
            createPointView.topAnchor.constraint(equalTo: view.topAnchor, constant: .xs),
            createPointView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.xs),
            createPointView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2 * screenThird),
            createPointView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.xs),
        ])

        return view
    }()

    let viewSwiperPointer: UIView = {
        let view = UIView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.opacity = 0.75  
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = CellMain.r2 / 2
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: CellMain.r2),
            view.heightAnchor.constraint(equalToConstant: CellMain.r2),
        ])

        return view
    }()

    lazy var fillerConstraint: NSLayoutConstraint = {
        let constraint = viewSwiperPointer.trailingAnchor.constraint(equalTo: viewSwiper.leadingAnchor)

        return constraint
    }()

    //

    // MARK: - Private properties

    //

    let emptyLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You have no entries yet. Do #SOME ACTION# to begin."
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

        backgroundColor = .systemBackground

        setupViewSwiper()

        addAndConstrain(viewTable)

        setupEmptyLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Behaviour

    //

    private func setupEmptyLabel() {
        addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            emptyLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupViewSwiper() {
        addSubview(viewSwiper)

        NSLayoutConstraint.activate([
            viewSwiper.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewSwiper.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])

        viewSwiper.addSubview(viewSwiperPointer)

        NSLayoutConstraint.activate([
            viewSwiperPointer.topAnchor.constraint(equalTo: viewSwiper.topAnchor, constant: .xs),
            fillerConstraint,
        ])
    }

    func showEmptyState() {
        emptyLabel.isHidden = false
    }

    func hideEmptyState() {
        emptyLabel.isHidden = true
    }
}
