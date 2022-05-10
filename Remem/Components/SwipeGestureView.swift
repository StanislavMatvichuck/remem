//
//  SwipeGestureView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.04.2022.
//

import UIKit

class SwipeGestureView: UIView {
    enum Mode {
        case vertical
        case horizontal
    }

    enum Durations: Double {
        case position = 0.7
    }

    // MARK: - Properties
    private var mode: Mode
    private var edgeInset: CGFloat
    private lazy var circleX: NSLayoutConstraint = {
        let initialAnchor: NSLayoutXAxisAnchor
        var constant: CGFloat = 0.0
        switch mode {
        case .vertical:
            initialAnchor = centerXAnchor
        case .horizontal:
            initialAnchor = leadingAnchor
            constant = edgeInset
        }
        return viewCircle.centerXAnchor.constraint(equalTo: initialAnchor, constant: constant)
    }()

    private lazy var circleY: NSLayoutConstraint = {
        let initialAnchor: NSLayoutYAxisAnchor
        var constant: CGFloat = 0.0
        switch mode {
        case .vertical:
            initialAnchor = bottomAnchor
            constant = edgeInset
        case .horizontal:
            initialAnchor = centerYAnchor
        }
        return viewCircle.centerYAnchor.constraint(equalTo: initialAnchor, constant: -constant)
    }()

    private lazy var viewCircle: UIView = {
        let view = UIView(al: true)
        view.layer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1).cgColor
        view.layer.cornerRadius = .r2 / 2
        view.isUserInteractionEnabled = false

        let littleSize = CGFloat.xs * 1.5
        let littleCenter = UIView(al: true)
        littleCenter.layer.backgroundColor = UIColor.systemBlue.cgColor
        littleCenter.layer.cornerRadius = littleSize / 2

        view.addSubview(littleCenter)
        NSLayoutConstraint.activate([
            littleCenter.widthAnchor.constraint(equalToConstant: littleSize),
            littleCenter.heightAnchor.constraint(equalToConstant: littleSize),
            littleCenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            littleCenter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .r2),
            view.heightAnchor.constraint(equalToConstant: .r2),
        ])

        return view
    }()

    private lazy var viewFinger: UIView = {
        let image = UIImage(systemName: "hand.point.up.left")?
            .withTintColor(.systemBlue.withAlphaComponent(1.0))
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font:
                .systemFont(ofSize: 64, weight: .regular)))

        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        let fingerDefaultAngle = -45 * CGFloat.pi / 360
        view.transform = CGAffineTransform(rotationAngle: fingerDefaultAngle)
        view.layer.anchorPoint = CGPoint(x: 423.0 / 668.0, y: 560.0 / 738.0)
        addSubview(view)
        return view
    }()

    // MARK: - Init
    init(mode: Mode, edgeInset: CGFloat) {
        self.mode = mode
        self.edgeInset = edgeInset
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension SwipeGestureView {
    func start() {
        switch mode {
        case .vertical:
            startVerticalAnimation()
        case .horizontal:
            startHorizontalAnimation()
        }
    }
}

// MARK: - Private
extension SwipeGestureView {
    private func startVerticalAnimation() {
        layoutIfNeeded()
        let verticalTravelDistance = bounds.height - 2 * edgeInset
        let circle = viewCircle.layer
        let finger = viewFinger.layer

        func createAnimation() -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "position.y")
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.duration = Durations.position.rawValue
            animation.repeatCount = .greatestFiniteMagnitude
            animation.isRemovedOnCompletion = false
            animation.autoreverses = true
            return animation
        }

        let circlePosition = createAnimation()
        circlePosition.fromValue = circle.position.y
        circlePosition.toValue = circle.position.y - verticalTravelDistance

        let fingerPosition = createAnimation()
        fingerPosition.fromValue = finger.position.y
        fingerPosition.toValue = finger.position.y - verticalTravelDistance

        circle.add(circlePosition, forKey: nil)
        finger.add(fingerPosition, forKey: nil)
    }

    private func startHorizontalAnimation() {
        layoutIfNeeded()
        let travelDistance = bounds.width - 2 * edgeInset
        let circle = viewCircle.layer
        let finger = viewFinger.layer

        func createAnimation() -> CABasicAnimation {
            let animation = CABasicAnimation(keyPath: "position.x")
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.duration = Durations.position.rawValue
            animation.repeatCount = .greatestFiniteMagnitude
            animation.isRemovedOnCompletion = false
            animation.autoreverses = true
            return animation
        }

        let circlePosition = createAnimation()
        circlePosition.fromValue = circle.position.x
        circlePosition.toValue = circle.position.x + travelDistance

        let fingerPosition = createAnimation()
        fingerPosition.fromValue = finger.position.x
        fingerPosition.toValue = finger.position.x + travelDistance

        circle.add(circlePosition, forKey: nil)
        finger.add(fingerPosition, forKey: nil)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([circleX, circleY])
        setupViewFingerConstraints()
    }

    private func setupViewFingerConstraints() {
        let finger = viewFinger
        let circle = viewCircle
        let labelSize = finger.sizeThatFits(CGSize(width: .wScreen, height: .hScreen))
        NSLayoutConstraint.activate([
            finger.centerXAnchor.constraint(equalTo: circle.centerXAnchor, constant: 0.75 * labelSize.width),
            finger.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: 0.56 * labelSize.height),
        ])
    }
}
