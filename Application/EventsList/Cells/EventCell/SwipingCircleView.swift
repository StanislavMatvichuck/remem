//
//  SwipingCircleView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 09.05.2023.
//

import UIKit

final class SwipingCircleView: UIControl {
    static let scale = CGFloat.buttonRadius / (.buttonRadius - .buttonMargin)
    static let plusSize = CGFloat.buttonRadius / 5

    private let circle: UIView = {
        let view = UIView(al: true)
        view.widthAnchor.constraint(equalToConstant: .swiperRadius * 2).isActive = true
        view.heightAnchor.constraint(equalToConstant: .swiperRadius * 2).isActive = true
        view.accessibilityIdentifier = "Swiper"
        view.isAccessibilityElement = true
        return view
    }()

    private let plusLayer: CALayer = {
        let center = CGFloat.swiperRadius

        let path = UIBezierPath()
        path.move(to: CGPoint(x: center - plusSize, y: center))
        path.addLine(to: CGPoint(x: center + plusSize, y: center))
        path.move(to: CGPoint(x: center, y: center - plusSize))
        path.addLine(to: CGPoint(x: center, y: center + plusSize))

        let plusLayer = CAShapeLayer()
        plusLayer.frame = CGRect(
            x: .zero, y: .zero,
            width: .buttonRadius * 2,
            height: .buttonRadius * 2
        )

        plusLayer.strokeColor = UIColor.bg_item.cgColor
        plusLayer.path = path.cgPath
        plusLayer.lineCap = .round
        plusLayer.lineWidth = 6.0
        return plusLayer
    }()

    private var width: CGFloat { bounds.width }
    private var animator: UIViewPropertyAnimator?

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        configurePanHandler()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureAnimatorIfNeeded() {
        guard animator == nil else { return }

        let animator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeInOut
        )
        animator.addAnimations {
            let transform = self.makeCircleTransform()
            self.circle.transform = transform
        }

        self.animator = animator
    }

    func prepareForReuse() { circle.transform = .identity }

    func prepareForHappeningCreationAnimation() {
        animator?.stopAnimation(true)
        animator?.finishAnimation(at: .end)
        animator = nil
    }

    func placeCircleAtLeft() {
        circle.transform = CGAffineTransform(translationX: -CGFloat.buttonHeight, y: 0)
    }

    func placeCircleAtDefault() {
        circle.transform = .identity
        layoutIfNeeded()
    }

    func hideCircle() { circle.isHidden = true }
    func showCircle() { circle.isHidden = false }

    // MARK: - Private
    private func configureLayout() {
        addSubview(circle)
        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 2 * CGFloat.buttonMargin),
            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func configureAppearance() {
        circle.backgroundColor = .primary
        circle.layer.addSublayer(plusLayer)
        circle.layer.cornerRadius = .swiperRadius
        circle.layer.borderColor = UIColor.border_primary.cgColor
        circle.layer.borderWidth = .border
    }

    private func configurePanHandler() {
        circle.addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan)
        ))
    }

    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        let translation = max(0, pan.translation(in: self).x)
        let progress = abs(translation * 4 / width)
        let progressSufficient = progress >= 1.0

        switch pan.state {
        case .began:
            configureAnimatorIfNeeded()
        case .changed:
            animator?.fractionComplete = progress
        default:
            progressSufficient ?
                sendActions(for: .valueChanged) :
                returnToStart(from: progress)
        }
    }

    private func makeCircleTransform() -> CGAffineTransform {
        var newTransform = CGAffineTransform.identity

        newTransform = newTransform.concatenating(CGAffineTransform(
            scaleX: Self.scale,
            y: Self.scale
        ))

        let totalWidth = width
        let circleWidth = circle.bounds.width
        let marginsCompensation = 4 * .buttonMargin
        let distance = totalWidth - circleWidth - marginsCompensation
        newTransform = newTransform.concatenating(CGAffineTransform(
            translationX: distance,
            y: 0
        ))

        return newTransform
    }

    private func returnToStart(from progress: CGFloat) {
        animator?.isReversed = true
        animator?.addCompletion { position in
            if position == .start { self.animator = nil }
        }
        animator?.continueAnimation(
            withTimingParameters: nil,
            durationFactor: progress
        )
    }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let plus = circle.layer.sublayers?.first as? CAShapeLayer {
            plus.strokeColor = UIColor.bg_item.cgColor
        }
    }
}
