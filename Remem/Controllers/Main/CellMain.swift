//
//  ViewMainRow.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

protocol CellMainDelegate: AnyObject {
    func didSwipeAction(_ cell: CellMain)
    func didAnimation(_ cell: CellMain)
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
        view.backgroundColor = .secondarySystemBackground
        return view
    }()

    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont(name: "Nunito", size: textSize)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = .label

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Nunito-Bold", size: textSize)
        label.numberOfLines = 1
        label.textColor = .systemBlue

        return label
    }()

    private let viewMovable: UIView = {
        let view = UIView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = CellMain.r1
        view.layer.backgroundColor = UIColor.tertiarySystemBackground.cgColor

        return view
    }()

    //

    // MARK: - Initialization

    //

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.transform = CGAffineTransform(scaleX: 1, y: -1)

        backgroundColor = .systemBackground

        setupEventHandlers()

        setupViewRoot()

        setupViewMovable()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        viewMovable.layer.backgroundColor = UIColor.tertiarySystemBackground.cgColor
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

            viewRoot.heightAnchor.constraint(equalToConstant: 2 * CellMain.r2),
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

    override func prepareForReuse() {
        super.prepareForReuse()

        movableCenterXPosition = movableCenterXInitialPosition
    }

    //

    // MARK: - Events handling

    //

    func setupEventHandlers() {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))

        viewMovable.addGestureRecognizer(gestureRecognizer)
    }

    //
    // Animations staff
    //

    private var isMovableViewInSuccessState: Bool {
        let leftAcceptanceValue = UIScreen.main.bounds.width - CellMain.r2 - 2 * .xs

        return movableCenterXPosition >= leftAcceptanceValue
    }

    private var movableCenterXPosition: CGFloat {
        get {
            return viewMovable.center.x
        }
        set {
            viewMovable.center.x = newValue
        }
    }

    private var movableCenterXInitialPosition: CGFloat {
        return CellMain.r2
    }

    private var movableCenterXSuccessPosition: CGFloat {
        return UIScreen.main.bounds.width - CellMain.r2 - 2 * .xs
    }

    @objc private func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let movedView = gestureRecognizer.view!

        let translation = gestureRecognizer.translation(in: contentView)

        let newXPosition = (movedView.center.x + translation.x * 2)
            .clamped(to: movableCenterXInitialPosition ... movableCenterXSuccessPosition)

        let newCenter = CGPoint(x: newXPosition, y: movedView.center.y)

        if
            gestureRecognizer.state == .began
        {
            UIDevice.vibrate(.light)
        } else if
            gestureRecognizer.state == .changed
        {
            movedView.center = newCenter

            gestureRecognizer.setTranslation(CGPoint.zero, in: contentView)
        } else if
            gestureRecognizer.state == .ended ||
            gestureRecognizer.state == .cancelled
        {
            if isMovableViewInSuccessState { delegate?.didSwipeAction(self) } else {
                animateMovableViewReturn()
            }
        }
    }

    // TODO: make single spring animation with proper reusability for the user

    func animateMovableViewReturn() {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = movableCenterXPosition
        animation.toValue = movableCenterXInitialPosition
        animation.duration = 0.3
        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)

        CATransaction.begin()

        movableCenterXPosition = movableCenterXInitialPosition
        viewMovable.layer.add(animation, forKey: nil)

        CATransaction.commit()
    }

    func animateMovableViewBack() {
        let animColor = CABasicAnimation(keyPath: "backgroundColor")
        animColor.fromValue = UIColor.tertiarySystemBackground.cgColor
        animColor.toValue = UIColor.systemBlue.cgColor
        animColor.timingFunction = CAMediaTimingFunction(name: .linear)
        animColor.autoreverses = true
        animColor.repeatCount = 1
        animColor.duration = 0.1

        let animScale = CABasicAnimation(keyPath: "transform.scale")
        animScale.fromValue = 1
        animScale.toValue = CellMain.r2 / CellMain.r1
        animScale.timingFunction = CAMediaTimingFunction(name: .linear)
        animScale.autoreverses = true
        animScale.repeatCount = 1
        animScale.duration = 0.1

        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = movableCenterXSuccessPosition
        animation.toValue = movableCenterXInitialPosition
        animation.duration = 0.3
        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.beginTime = CACurrentMediaTime() + 0.2

        CATransaction.begin()

        CATransaction.setCompletionBlock {
            self.delegate?.didAnimation(self)
        }

        viewMovable.layer.position.x = movableCenterXInitialPosition
        viewMovable.layer.add(animScale, forKey: nil)
        viewMovable.layer.add(animColor, forKey: nil)
        viewMovable.layer.add(animation, forKey: nil)

        CATransaction.commit()
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
