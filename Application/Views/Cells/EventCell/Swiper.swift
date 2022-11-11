//
//  Swiper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 29.08.2022.
//

import UIKit

class Swiper: UIControl {
    // MARK: - Properties
    let parent: UIView
    let initialConstant: CGFloat = .r2
    var successConstant: CGFloat { parent.bounds.width - .r2 }
    var horizontalConstraint: NSLayoutConstraint!
    lazy var recognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePan)
    )

    // MARK: - Init
    init(parent: UIView) {
        self.parent = parent
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        addGestureRecognizer(recognizer)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        horizontalConstraint = centerXAnchor.constraint(equalTo: parent.leadingAnchor, constant: .r2)

        parent.addSubview(self)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: .d1),
            heightAnchor.constraint(equalToConstant: .d1),

            horizontalConstraint,
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        layer.backgroundColor = EventCell.pinColor.cgColor
        layer.cornerRadius = .r1
    }
}

// MARK: - Pan handling
extension Swiper {
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            UIDevice.vibrate(.light)
        case .changed:
            let translation = gestureRecognizer.translation(in: parent)
            let xDelta = translation.x * 2
            let newXPosition = horizontalConstraint.constant + xDelta

            horizontalConstraint.constant = newXPosition.clamped(to: initialConstant ... successConstant)
            gestureRecognizer.setTranslation(CGPoint.zero, in: parent)
        case .ended, .cancelled:
            if horizontalConstraint.constant >= successConstant {
                sendActions(for: .primaryActionTriggered)
            } else {
                animateToInitialConstant()
            }
        default: return
        }
    }

    func animateToInitialConstant() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.horizontalConstraint.constant = self.initialConstant
            self.parent.layoutIfNeeded()
        }, completion: nil)
    }

    func animateSuccess() {
        let background = CABasicAnimation(keyPath: "backgroundColor")
        background.fromValue = layer.backgroundColor
        background.toValue = UIHelper.brand.cgColor

        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1.0
        scale.toValue = CGFloat.r2 / CGFloat.r1

        let group = CAAnimationGroup()
        group.autoreverses = true
        group.repeatCount = 1
        group.duration = 0.1
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.fillMode = .backwards
        group.animations = [background, scale]

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.animateToInitialConstant()
        }
        layer.add(group, forKey: nil)
        CATransaction.commit()
    }
}

// MARK: - Dark mode
extension Swiper {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = EventCell.pinColor.cgColor
    }
}
