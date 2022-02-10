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

        view.backgroundColor = .clear

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            view.heightAnchor.constraint(equalToConstant: 2 * .xs + CellMain.r2),
        ])

        return view
    }()

    let viewCreatePoint: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = CellMain.r2 / 2
        view.layer.opacity = 0.75

        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito", size: 18)
        label.text = "point"
        label.textAlignment = .center
        label.textColor = .label

        view.addAndConstrain(label)

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

        input.font = UIFont(name: "Nunito", size: CellMain.textSize)
        input.textAlignment = .center
        input.backgroundColor = .clear

        view.addSubview(input)
        view.layer.cornerRadius = CellMain.r2
        view.isOpaque = true

        let circle = UIView(frame: .zero)
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.layer.cornerRadius = CellMain.r1
        circle.backgroundColor = .systemBackground

        view.addSubview(circle)

        let valueLabel: UILabel = {
            let label = UILabel(frame: .zero)

            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Nunito-Bold", size: CellMain.textSize)
            label.numberOfLines = 1
            label.textColor = .systemBlue
            label.text = "0"

            return label
        }()
        
        view.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .wScreen - .sm),
            view.heightAnchor.constraint(equalToConstant: 2 * CellMain.r2),

            input.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            input.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            input.heightAnchor.constraint(equalToConstant: 2 * CellMain.r1),
            input.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -4 * CellMain.r2),

            circle.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            circle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .xs),
            circle.widthAnchor.constraint(equalToConstant: 2 * CellMain.r1),
            circle.heightAnchor.constraint(equalToConstant: 2 * CellMain.r1),

            valueLabel.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -CellMain.r2),
            valueLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        return view
    }()

    var input: UITextView {
        viewInput.subviews[0] as! UITextView
    }

    lazy var fillerConstraint: NSLayoutConstraint = {
        viewSwiperPointer.trailingAnchor.constraint(equalTo: viewSwiper.leadingAnchor)
    }()

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

        backgroundColor = .systemBackground

        setupViewSwiper()

        addAndConstrain(viewTable)

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

        viewSwiper.addSubview(viewCreatePoint)

        let screenThird = UIScreen.main.bounds.width / 3

        NSLayoutConstraint.activate([
            viewCreatePoint.topAnchor.constraint(equalTo: viewSwiper.topAnchor, constant: .xs),
            viewCreatePoint.bottomAnchor.constraint(equalTo: viewSwiper.bottomAnchor, constant: -.xs),
            viewCreatePoint.leadingAnchor.constraint(equalTo: viewSwiper.leadingAnchor, constant: 2 * screenThird),
            viewCreatePoint.trailingAnchor.constraint(equalTo: viewSwiper.trailingAnchor, constant: -.xs),
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

    // MARK: - Events handling

    //

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        viewCreatePoint.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
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

    //

    // MARK: - Animations

    //

    private var isViewCreatePointSelected = false

    func animateViewCreatePointSelectedState(to isSelected: Bool) {
        guard isSelected != isViewCreatePointSelected else { return }

        let animation = createSelectedAnimation(isSelected: isSelected)

        viewCreatePoint.layer.backgroundColor = isSelected ?
            UIColor.systemBlue.cgColor :
            UIColor.secondarySystemBackground.cgColor

        viewCreatePoint.layer.add(animation, forKey: nil)

        isViewCreatePointSelected = isSelected

        if isSelected {
            UIDevice.vibrate(.soft)
        }
    }

    private func createSelectedAnimation(isSelected: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "backgroundColor")

        animation.fromValue = isSelected ? UIColor.secondarySystemBackground : UIColor.systemBlue
        animation.toValue = isSelected ? UIColor.systemBlue : UIColor.secondarySystemBackground

        animation.duration = 0.2

        animation.timingFunction = CAMediaTimingFunction(name: .linear)

        return animation
    }
}
