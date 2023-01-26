//
//  SwipeGestureView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.04.2022.
//

import UIKit

protocol UsingSwipingHintDisplaying: UIView {
    var swipingHint: SwipingHintDisplaying? { get }
    @discardableResult func addSwipingHint() -> SwipingHintDisplaying
    func removeSwipingHint()
}

protocol SwipingHintDisplaying: UIView {
    func startAnimation()
    var animatedPosition: CGFloat { get }
    var animationCompletionHandler: (() -> Void)? { get set }
}

extension UsingSwipingHintDisplaying {
    var swipingHint: SwipingHintDisplaying? {
        subviews.filter {
            $0 is SwipingHintDisplaying
        }.first as? SwipingHintDisplaying
    }

    @discardableResult
    func addSwipingHint() -> SwipingHintDisplaying {
        let view = SwipingHintDisplay()
        addSubview(view)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        return view
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
        horizontalConstraint?.constant ?? 0
    }

    private var horizontalConstraint: NSLayoutConstraint?
    private let circle: UIView = {
        let view = UIView(al: true)
        view.isUserInteractionEnabled = false

        let littleSize = UIHelper.delta1 * 1.5
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

        return view
    }()

    private let finger: UIView = {
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

        return view
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        addSubview(circle)
        addSubview(finger)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        startAnimation()
    }

    func startAnimation() {
        let animator = UIViewPropertyAnimator(
            duration: 1.5,
            timingParameters: UICubicTimingParameters()
        )
        animator.addAnimations {
            self.horizontalConstraint?.constant = self.bounds.width - self.circle.bounds.height
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
            duration: 1.5,
            timingParameters: UICubicTimingParameters()
        )
        animator.addAnimations {
            self.horizontalConstraint?.constant = 0
            self.layoutIfNeeded()
        }
        animator.addCompletion { _ in
            self.animationCompletionHandler?()
            self.startAnimation()
        }
        animator.startAnimation()
    }

    private func setupConstraints() {
        let horizontalConstraint = circle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        self.horizontalConstraint = horizontalConstraint

        let labelSize = finger.sizeThatFits(UIScreen.main.bounds.size)
        NSLayoutConstraint.activate([
            finger.centerXAnchor.constraint(equalTo: circle.centerXAnchor, constant: 0.75 * labelSize.width),
            finger.centerYAnchor.constraint(equalTo: circle.centerYAnchor, constant: 0.56 * labelSize.height),

            circle.topAnchor.constraint(equalTo: topAnchor),
            circle.heightAnchor.constraint(equalTo: heightAnchor),
            circle.widthAnchor.constraint(equalTo: circle.heightAnchor),
            horizontalConstraint,
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circle.layer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1).cgColor
        circle.layer.cornerRadius = circle.bounds.width / 2
    }
}
