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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        viewCreatePoint.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
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

        viewSwiper.addSubview(viewCreatePoint)

        let screenThird = UIScreen.main.bounds.width / 3

        NSLayoutConstraint.activate([
            viewCreatePoint.topAnchor.constraint(equalTo: viewSwiper.topAnchor, constant: .xs),
            viewCreatePoint.bottomAnchor.constraint(equalTo: viewSwiper.bottomAnchor, constant: -.xs),
            viewCreatePoint.leadingAnchor.constraint(equalTo: viewSwiper.leadingAnchor, constant: 2 * screenThird),
            viewCreatePoint.trailingAnchor.constraint(equalTo: viewSwiper.trailingAnchor, constant: -.xs),
        ])
    }

    func showEmptyState() {
        emptyLabel.isHidden = false
    }

    func hideEmptyState() {
        emptyLabel.isHidden = true
    }

//    var isPointerAnimated = false
    var isPointerSmall = false

    func animatePointSelector() {
        guard !isPointerSmall else { return }

//        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor.secondarySystemBackground.cgColor
        animation.toValue = UIColor.systemBlue.cgColor
        animation.duration = 0.2
//        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)

//        CATransaction.begin()
//
//        CATransaction.setCompletionBlock {
//            self.isPointerSmall = true
//        }

//        viewCreatePoint.transform = CGAffineTransform(scaleX: 1, y: 0.8)
        viewCreatePoint.layer.backgroundColor = UIColor.systemBlue.cgColor
        viewCreatePoint.layer.add(animation, forKey: nil)

//        isPointerAnimated = true
        isPointerSmall = true
        UIDevice.vibrate(.soft)

//        CATransaction.commit()
    }

    func reversePointSelectorAnimation() {
        guard isPointerSmall else { return }
//
//        let animation = CABasicAnimation(keyPath: "transform.scale.y")
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.fromValue = UIColor.systemBlue.cgColor
        animation.toValue = UIColor.secondarySystemBackground.cgColor
        animation.duration = 0.2
//        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
//
        CATransaction.begin()
//
        CATransaction.setCompletionBlock {
            self.isPointerSmall = false
        }
//
//        viewCreatePoint.transform = CGAffineTransform.identity
        viewCreatePoint.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
        viewCreatePoint.layer.add(animation, forKey: nil)

        isPointerSmall = false
        UIDevice.vibrate(.soft)
//
        CATransaction.commit()
    }
}
