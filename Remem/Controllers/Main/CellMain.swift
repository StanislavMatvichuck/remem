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

    static let textSize: CGFloat = 24

    static var r1: CGFloat {
        return 40
    }

    static var r2: CGFloat {
        return r1 + .xs
    }

    //
    // Layout
    //

    private let viewRoot: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = CellMain.r2
        view.backgroundColor = .orange
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: textSize, weight: .medium)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping

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
        view.layer.cornerRadius = CellMain.r1

        return view
    }()

    //

    // MARK: - Initialization

    //

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

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
            nameLabel.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: 2 * CellMain.r2),
            nameLabel.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -2 * CellMain.r2),

            nameLabel.topAnchor.constraint(equalTo: viewRoot.topAnchor, constant: CellMain.r2 - CellMain.r1),
            nameLabel.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor, constant: -(CellMain.r2 - CellMain.r1)),

            valueLabel.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -CellMain.r2),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
            
            viewRoot.heightAnchor.constraint(equalToConstant: 2 * CellMain.r2)
        ])

        contentView.addAndConstrain(viewRoot, constant: .xs)
    }

    private func setupViewMovable() {
        viewRoot.addSubview(viewMovable)

        NSLayoutConstraint.activate([
            viewMovable.widthAnchor.constraint(equalToConstant: 2 * CellMain.r1),
            viewMovable.heightAnchor.constraint(equalToConstant: 2 * CellMain.r1),

            viewMovable.centerXAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: CellMain.r2),
            viewMovable.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
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
        let leftAcceptanceValue = UIScreen.main.bounds.width - CellMain.r2 - 2 * .xs

        return movableCenterXPosition >= leftAcceptanceValue
    }

    private var movableCenterXPosition: CGFloat {
        return viewMovable.center.x
    }

    private var movableCenterXInitialPosition: CGFloat {
        return CellMain.r2
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let movedView = gestureRecognizer.view!

        let translation = gestureRecognizer.translation(in: contentView)

        let maximumWidth = UIScreen.main.bounds.width - CellMain.r2 - 2 * .xs

        let newXPosition = (movedView.center.x + translation.x * 2)
            .clamped(to: CellMain.r2 ... maximumWidth)

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
                movedView.center = CGPoint(x: CellMain.r2, y: movedView.center.y)
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
