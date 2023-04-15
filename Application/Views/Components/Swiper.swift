//
//  Swiper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 29.08.2022.
//

import UIKit

final class Swiper: UIControl {
    var initialX: CGFloat { .buttonRadius }
    var width: CGFloat { superview!.bounds.width }
    var successX: CGFloat { width - initialX }
    var size: CGFloat = 2 * .swiperRadius
    var scaleFactor: CGFloat { .buttonHeight / size }

    var swipeAnimator: UIViewPropertyAnimator?
    var verticalTranslation: CGFloat = 0

    lazy var plusLayer: CAShapeLayer = {
        let plusSize = size / 12
        let center = size / 2

        let path = UIBezierPath()
        path.move(to: CGPoint(x: center - plusSize, y: center))
        path.addLine(to: CGPoint(x: center + plusSize, y: center))
        path.move(to: CGPoint(x: center, y: center - plusSize))
        path.addLine(to: CGPoint(x: center, y: center + plusSize))

        let plusLayer = CAShapeLayer()
        plusLayer.frame = CGRect(x: .zero, y: .zero, width: size, height: size)
        plusLayer.strokeColor = UIColor.background_secondary.cgColor
        plusLayer.path = path.cgPath
        plusLayer.lineCap = .round
        plusLayer.lineWidth = 3.0
        return plusLayer
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        accessibilityIdentifier = "Swiper"
        isAccessibilityElement = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureLayout()
        configureAppearance()
        addGestureRecognizer(UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePan)
        ))
    }

    private func configureLayout() {
        guard let superview else { return }
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),

            centerXAnchor.constraint(equalTo: superview.leadingAnchor, constant: initialX),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        layer.backgroundColor = UIColor.primary.cgColor
        layer.cornerRadius = .swiperRadius
        layer.addSublayer(plusLayer)
    }
}

// MARK: - Pan handling
extension Swiper {
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        guard let parent = gestureRecognizer.view else { return }

        let translation = gestureRecognizer.translation(in: parent)
        let xDelta = translation.x * 2
        let newXPosition = verticalTranslation + xDelta
        let progress = (newXPosition - initialX) / (successX - initialX)

        switch gestureRecognizer.state {
        case .began:
            makeSwipeAnimator()
        case .changed:
            verticalTranslation = newXPosition
            swipeAnimator?.fractionComplete = progress
            gestureRecognizer.setTranslation(CGPoint.zero, in: parent)
        case .ended, .cancelled:
            print("progress \(progress)")
            if progress >= 1.0 {
                animateSuccess()
            } else {
                swipeAnimator?.isReversed = true
                swipeAnimator?.continueAnimation(
                    withTimingParameters: nil,
                    durationFactor: progress
                )
            }
            verticalTranslation = 0
        default: return
        }
    }

    func animateFromSuccess() {
        let returnAnimator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeOut
        ) {
            self.superview?.transform = .identity
            self.alpha = 0
        }

        returnAnimator.addCompletion { _ in
            self.swipeAnimator?.stopAnimation(true)
            self.swipeAnimator?.finishAnimation(at: .start)
            self.swipeAnimator = nil
            self.transform = .identity
            self.verticalTranslation = 0

            let appearanceAnimator = UIViewPropertyAnimator(
                duration: SwiperAnimationsHelper.forwardDuration,
                curve: .easeInOut
            ) {
                self.alpha = 1
            }

            appearanceAnimator.startAnimation()
        }

        returnAnimator.startAnimation()
    }

    func resetToInitialStateWithoutAnimation() {
        transform = .identity
        superview?.layoutIfNeeded()
    }

    // MARK: - Private

    private func makeSwipeAnimator() {
        resetSwipeAnimator()

        let sizeAnimator = UIViewPropertyAnimator(
            duration: 0.5,
            curve: .linear
        ) {
            var newTransform = CGAffineTransform.identity

            newTransform = newTransform.concatenating(CGAffineTransform(
                scaleX: self.scaleFactor,
                y: self.scaleFactor
            ))

            newTransform = newTransform.concatenating(CGAffineTransform(
                translationX: self.successX - self.initialX,
                y: 0
            ))

            self.transform = newTransform
        }

        sizeAnimator.pausesOnCompletion = true

        swipeAnimator = sizeAnimator
    }

    private func resetSwipeAnimator() {
        swipeAnimator?.stopAnimation(true)
        swipeAnimator?.finishAnimation(at: .start)
        swipeAnimator = nil
    }

    private func animateSuccess() {
        let forwardAnimator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.forwardDuration,
            curve: .easeOut
        ) {
            self.superview?.transform = CGAffineTransform(
                translationX: .buttonMargin,
                y: 0
            )
        }

        forwardAnimator.addCompletion { _ in
            self.sendActions(for: .primaryActionTriggered)
        }

        let dropAnimator = UIViewPropertyAnimator(
            duration: SwiperAnimationsHelper.dropDuration,
            curve: .easeIn
        ) {
            self.transform = CGAffineTransform(
                translationX: self.successX - self.initialX,
                y: 0
            )
        }

        dropAnimator.addCompletion { _ in
            forwardAnimator.startAnimation()
        }

        dropAnimator.startAnimation()
    }
}

// MARK: - Dark mode
extension Swiper {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = UIColor.primary.cgColor
        plusLayer.strokeColor = UIColor.background_secondary.cgColor
    }
}
