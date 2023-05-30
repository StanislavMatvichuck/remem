//
//  SwipeGestureView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.04.2022.
//

import UIKit

protocol UsingSwipingHintDisplaying: UIView {
    var swipingHint: SwipingHintDisplaying? { get }
    func addSwipingHint()
    func removeSwipingHint()
}

protocol SwipingHintDisplaying: UIView {
    func startAnimation()
    var animatedPosition: CGFloat { get }
    var animationCompletionHandler: (() -> Void)? { get set }
}

extension UIView: UsingSwipingHintDisplaying {
    var swipingHint: SwipingHintDisplaying? {
        subviews.filter {
            $0 is SwipingHintDisplaying
        }.first as? SwipingHintDisplaying
    }

    func addSwipingHint() {
        guard parseTestingLaunchParameters().isEmpty else { return }
        let display = SwipingHintDisplay()
        addAndConstrain(display)
        layoutIfNeeded()
        display.startAnimation()
    }

    func removeSwipingHint() {
        if let view = swipingHint {
            view.removeFromSuperview()
        }
    }
}

final class SwipingHintDisplay: UIView, SwipingHintDisplaying {
    var animationCompletionHandler: (() -> Void)?

    var animatedPosition: CGFloat {
        horizontalConstraint?.constant ?? initialConstant
    }

    private var duration: Double { 1.6 }
    private var initialConstant: CGFloat { .buttonRadius + .buttonMargin }
    private var finalConstant: CGFloat { bounds.width - initialConstant }

    private var horizontalConstraint: NSLayoutConstraint?
    private let circle: UIView = {
        let view = UIView(al: true)
        view.isUserInteractionEnabled = false

        let littleSize = CGFloat.buttonMargin
        let littleCenter = UIView(al: true)
        littleCenter.layer.backgroundColor = UIColor.clear.cgColor
        littleCenter.layer.cornerRadius = littleSize / 2

        view.addSubview(littleCenter)
        NSLayoutConstraint.activate([
            littleCenter.widthAnchor.constraint(equalToConstant: littleSize),
            littleCenter.heightAnchor.constraint(equalToConstant: littleSize),
            littleCenter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            littleCenter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        return view
    }()

    private let finger: UIView = {
        let image = UIImage(systemName: "hand.point.up.left")?
            .withTintColor(.secondary.withAlphaComponent(1.0))
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font:
                .systemFont(ofSize: 40, weight: .regular)))

        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        let fingerDefaultAngle = -45 * CGFloat.pi / 360
        view.transform = CGAffineTransform(rotationAngle: fingerDefaultAngle)
        view.layer.anchorPoint = CGPoint(x: 423.0 / 668.0, y: 560.0 / 738.0)

        return view
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupConstraints()
    }

    func startAnimation() {
        let animator = UIViewPropertyAnimator(
            duration: duration,
            timingParameters: UICubicTimingParameters()
        )
        animator.addAnimations {
            self.horizontalConstraint?.constant = self.finalConstant
            self.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.animationCompletionHandler?()
            self.startReverseAnimation()
        }
        animator.startAnimation()
    }

    private func startReverseAnimation() {
        let animator = UIViewPropertyAnimator(
            duration: duration,
            timingParameters: UICubicTimingParameters()
        )
        animator.addAnimations {
            self.horizontalConstraint?.constant = self.initialConstant
            self.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.animationCompletionHandler?()
            self.startAnimation()
        }
        animator.startAnimation()
    }

    private func setupConstraints() {
        addSubview(circle)
        addSubview(finger)

        let horizontalConstraint = circle.centerXAnchor.constraint(equalTo: leadingAnchor, constant: initialConstant)
        self.horizontalConstraint = horizontalConstraint

        let labelSize = finger.sizeThatFits(UIScreen.main.bounds.size)
        NSLayoutConstraint.activate([
            finger.centerXAnchor.constraint(equalTo: circle.centerXAnchor, constant: 0.75 * labelSize.width),
            finger.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: 0.56 * labelSize.height),

            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 3),
            circle.widthAnchor.constraint(equalTo: circle.heightAnchor),
            horizontalConstraint,
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circle.layer.backgroundColor = UIColor.secondary.withAlphaComponent(0.1).cgColor
        circle.layer.cornerRadius = circle.bounds.width / 2
    }

    override func updateConstraints() {
        super.updateConstraints()
    }
}
