//
//  Swiper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 29.08.2022.
//

import UIKit

class Swiper: UIControl {
    // MARK: - Properties
    let initialX: CGFloat = UIHelper.r2
    let size: CGFloat = UIHelper.d1
    var smallSize: CGFloat { UIHelper.r0 / UIHelper.r1 }
    var rotation: CGFloat { CGFloat.pi / 2 }
    var width: CGFloat { superview?.bounds.width ?? .greatestFiniteMagnitude }
    var successX: CGFloat { width - UIHelper.r2 }
    var durationMultiplier: Double { 1 }
    var successDuration: Double { durationMultiplier * 0.2 }
    var fromSuccessDuration: Double { durationMultiplier * 0.2 }
    var returnDuration: Double { durationMultiplier * 0.2 }

    var horizontalConstraint: NSLayoutConstraint!
    var returnCompletionHandler: ((Bool) -> Void)?
    var successCompletionHandler: ((Bool) -> Void)?

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
        addGestureRecognizer(
            UIPanGestureRecognizer(
                target: self,
                action: #selector(handlePan)
            )
        )
    }

    private func configureLayout() {
        guard let superview else { return }

        horizontalConstraint = centerXAnchor.constraint(
            equalTo: superview.leadingAnchor,
            constant: initialX
        )

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size),

            horizontalConstraint,
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }

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
        plusLayer.strokeColor = UIHelper.brand.cgColor
        plusLayer.path = path.cgPath
        plusLayer.lineCap = .round
        plusLayer.lineWidth = 3.0
        return plusLayer
    }()

    private func configureAppearance() {
        layer.backgroundColor = UIHelper.pinColor.cgColor
        layer.cornerRadius = UIHelper.r1
        layer.addSublayer(plusLayer)
    }
}

// MARK: - Pan handling
extension Swiper {
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        guard let parent = gestureRecognizer.view else { return }

        switch gestureRecognizer.state {
        case .began:
            UIDevice.vibrate(.light)
        case .changed:
            let translation = gestureRecognizer.translation(in: parent)
            let xDelta = translation.x * 2
            let newXPosition = horizontalConstraint.constant + xDelta

            horizontalConstraint.constant = newXPosition.clamped(to: initialX ... successX)
            gestureRecognizer.setTranslation(CGPoint.zero, in: parent)
        case .ended, .cancelled:
            if horizontalConstraint.constant == successX {
                animateSuccess()
            } else {
                animateToInitialConstant()
            }
        default: return
        }
    }

    private func animateSuccess() {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = smallSize

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0.0
        rotation.toValue = self.rotation

        let group = CAAnimationGroup()
        group.duration = successDuration
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .backwards
        group.animations = [scale, rotation]
        group.delegate = self
        group.setValue("success", forKey: "name")

        transform = CGAffineTransform(scaleX: UIHelper.r0 / UIHelper.r1, y: UIHelper.r0 / UIHelper.r1)
        layer.add(group, forKey: nil)
    }

    private func animateToInitialConstant() {
        UIView.animate(
            withDuration: returnDuration,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.horizontalConstraint.constant = self.initialX
                self.superview?.layoutIfNeeded()
            },
            completion: returnCompletionHandler
        )
    }

    func animateFromSuccess() {
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = smallSize
        scale.toValue = 1

        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = self.rotation
        rotation.toValue = 0

        let group = CAAnimationGroup()
        group.duration = fromSuccessDuration
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .backwards
        group.animations = [scale, rotation]
        group.setValue("fromSuccess", forKey: "name")
        group.delegate = self

        transform = .identity
        layer.add(group, forKey: nil)
    }

    func resetToInitialStateWithoutAnimation() {
        horizontalConstraint.constant = initialX
        superview?.layoutIfNeeded()
    }
}

// MARK: - Dark mode
extension Swiper {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = UIHelper.pinColor.cgColor
    }
}

extension Swiper: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }

        if let name = anim.value(forKey: "name") as? String {
            if name == "success" {
                sendActions(for: .primaryActionTriggered)
                UIDevice.vibrate(.heavy)
            }

            if name == "fromSuccess" {
                animateToInitialConstant()
            }
        }
    }
}
