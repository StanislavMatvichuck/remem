//
//  ViewMainRow.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

protocol EntryCellDelegate: AnyObject {
    func didSwipeAction(_ cell: EntryCell)
    func didPressAction(_ cell: EntryCell)
    func didAnimation(_ cell: EntryCell)
}

final class EntryCell: UITableViewCell {
    // MARK: - Static properties
    static let reuseIdentifier = "ViewMainRow"
    static let backgroundColor = UIColor.systemBackground
    static let pinColor = UIColor.secondarySystemBackground
    static let height = .d2 + .sm
    // MARK: - Public properties
    weak var delegate: EntryCellDelegate?
    weak var animator: EntryCellAnimator?

    var movableCenterXSuccessPosition: CGFloat { viewRoot.bounds.width - .r2 }
    var movableCenterXInitialPosition: CGFloat { .r2 }
    var movableCenterXPosition: CGFloat {
        get { viewMovable.layer.position.x }
        set { viewMovable.layer.position.x = newValue }
    }

    let viewRoot: UIView = {
        let view = UIView(al: true)
        view.layer.cornerRadius = .r2
        view.backgroundColor = EntryCell.backgroundColor
        return view
    }()

    let viewMovable: UIView = {
        let view = UIView(al: true)
        view.layer.cornerRadius = .r1
        view.backgroundColor = EntryCell.pinColor
        return view
    }()

    let valueLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: .font2, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .systemBlue
        return label
    }()

    // MARK: - Private properties
    private let nameLabel: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: .font2, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.textColor = .label
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViewRoot()
        setupViewMovable()
        setupEventHandlers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupViewRoot() {
        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        viewRoot.addSubview(nameLabel)
        viewRoot.addSubview(valueLabel)

        contentView.addSubview(viewRoot)

        let height = contentView.heightAnchor.constraint(equalToConstant: Self.height)
        height.priority = .defaultLow /// tableView constraints fix

        NSLayoutConstraint.activate([
            height,
            nameLabel.centerXAnchor.constraint(equalTo: viewRoot.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: .d2),
            nameLabel.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, constant: -2 * .d2),

            valueLabel.centerXAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.r2),
            valueLabel.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),

            viewRoot.heightAnchor.constraint(equalToConstant: .d2),

            viewRoot.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            viewRoot.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
            viewRoot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    private func setupViewMovable() {
        viewRoot.addSubview(viewMovable)

        NSLayoutConstraint.activate([
            viewMovable.widthAnchor.constraint(equalToConstant: .d1),
            viewMovable.heightAnchor.constraint(equalToConstant: .d1),

            viewMovable.centerXAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .r2),
            viewMovable.centerYAnchor.constraint(equalTo: viewRoot.centerYAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movableCenterXPosition = movableCenterXInitialPosition
    }
}

// MARK: - Public
extension EntryCell {
    func update(name: String) {
        nameLabel.text = name
    }

    func update(value: Int) {
        valueLabel.text = "\(value)"
    }
}

// MARK: - User input
extension EntryCell {
    private func setupEventHandlers() {
        viewMovable.addGestureRecognizer(UIPanGestureRecognizer(
            target: self, action: #selector(handlePan)))
        viewRoot.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(handlePress)))
    }

    @objc private func handlePress(_ gestureRecognizer: UITapGestureRecognizer) {
        delegate?.didPressAction(self)
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        var isMovableViewInSuccessState: Bool {
            let leftAcceptanceValue = UIScreen.main.bounds.width - .r2 - 2 * .xs
            return movableCenterXPosition >= leftAcceptanceValue
        }

        let movedView = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: contentView)
        let newXPosition = (movedView.center.x + translation.x * 2)
            .clamped(to: movableCenterXInitialPosition ... movableCenterXSuccessPosition)
        let newCenter = CGPoint(x: newXPosition, y: movedView.center.y)

        if gestureRecognizer.state == .began {
            UIDevice.vibrate(.light)
        } else if gestureRecognizer.state == .changed {
            movedView.center = newCenter
            gestureRecognizer.setTranslation(CGPoint.zero, in: contentView)
        } else if
            gestureRecognizer.state == .ended ||
            gestureRecognizer.state == .cancelled
        {
            if movableCenterXPosition >= movableCenterXSuccessPosition {
                delegate?.didSwipeAction(self)
            } else {
                animator?.handleUnfinishedSwipe(cell: self)
            }
        }
    }
}

// MARK: - Dark mode
extension EntryCell {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewMovable.layer.backgroundColor = Self.pinColor.cgColor
        viewRoot.layer.backgroundColor = Self.backgroundColor.cgColor
    }
}
