//
//  ViewMainRow.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

protocol CellMainDelegate: AnyObject {
    func didPress(cell: CellMain)
}

class CellMain: UITableViewCell {
    //

    // MARK: - Static properties

    //

    static let reuseIdentifier = "ViewMainRow"

    //

    // MARK: - Public properties

    //

    weak var delegate: CellMainDelegate?

    //

    // MARK: - Private properties

    //

    private let viewRoot: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1

        return label
    }()

    private let viewMovable: UIView = {
        let view = UIView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.gray.cgColor
        view.alpha = 0.75

        return view
    }()

    //

    // MARK: - Initialization

    //

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .orange

        setupEventHandlers()

        setupViewRoot()

        setupViewMovable()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViewRoot() {
        viewRoot.addSubview(nameLabel)
        viewRoot.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .hButton),
            nameLabel.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.hButton),

            nameLabel.topAnchor.constraint(equalTo: viewRoot.topAnchor, constant: .md),
            nameLabel.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor, constant: -.md),

            valueLabel.leadingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.hButton),
            valueLabel.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
        ])

        contentView.addAndConstrain(viewRoot)
    }

    private func setupViewMovable() {
        viewRoot.addSubview(viewMovable)

        NSLayoutConstraint.activate([
            viewMovable.widthAnchor.constraint(equalToConstant: .hButton),
            viewMovable.heightAnchor.constraint(equalTo: viewRoot.heightAnchor),
        ])
    }

    //

    // MARK: - Events handling

    //

    func setupEventHandlers() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handlePress))

        contentView.addGestureRecognizer(recognizer)

        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

        viewMovable.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func handlePress() {
        delegate?.didPress(cell: self)
    }

    //
    // Animations staff
    //

    private var isMovableViewInSuccessState: Bool {
        let leftAcceptanceValue = UIScreen.main.bounds.width - movedViewXCompensation

        return movableCenterXPosition >= leftAcceptanceValue
    }

    private var movedViewXCompensation: CGFloat {
        return viewMovable.bounds.width / 2
    }

    private var movableCenterXPosition: CGFloat {
        return viewMovable.center.x
    }

    private var movableCenterXInitialPosition: CGFloat {
        return viewMovable.bounds.width / 2
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let movedView = gestureRecognizer.view!

        let translation = gestureRecognizer.translation(in: contentView)

        let maximumWidth = UIScreen.main.bounds.width - movedViewXCompensation

        let newXPosition = (movedView.center.x + translation.x * 1.5)
            .clamped(to: movedViewXCompensation ... maximumWidth)

        let newCenter = CGPoint(x: newXPosition, y: movedView.center.y)

        if
            gestureRecognizer.state == .began ||
            gestureRecognizer.state == .changed
        {
            movedView.center = newCenter

            gestureRecognizer.setTranslation(CGPoint.zero, in: contentView)
        } else if
            gestureRecognizer.state == .ended ||
            gestureRecognizer.state == .cancelled
        {
            if isMovableViewInSuccessState {
                delegate?.didPress(cell: self)
            }

            UIView.animate(withDuration: 0.25, animations: {
                movedView.center = CGPoint(x: self.movedViewXCompensation, y: movedView.bounds.height / 2)
            })
        }
    }

    //

    // MARK: - Behaviour

    //

    func update(name: String) {
        nameLabel.text = name
    }

    func update(value: Int) {
        valueLabel.text = "\(value)"
    }
}
