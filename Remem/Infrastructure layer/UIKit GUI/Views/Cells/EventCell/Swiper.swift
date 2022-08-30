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
    var successPosition: CGFloat { parent.bounds.width - .r2 }
    let initialPosition: CGFloat = .r2
    // MARK: - Init
    init(parent: UIView) {
        self.parent = parent
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        configurePanHandler()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        parent.addSubview(self)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: .d1),
            heightAnchor.constraint(equalToConstant: .d1),

            centerXAnchor.constraint(equalTo: parent.leadingAnchor, constant: .r2),
            centerYAnchor.constraint(equalTo: parent.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        layer.backgroundColor = EventCell.pinColor.cgColor
        layer.cornerRadius = .r1
    }

    private func configurePanHandler() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(pan)
    }
}

// MARK: - Pan handling
extension Swiper {
    var position: CGFloat {
        get { layer.position.x }
        set { layer.position.x = newValue }
    }

    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            UIDevice.vibrate(.light)
        case .changed:
            let translation = gestureRecognizer.translation(in: parent)
            let xDelta = translation.x * 2
            let newXPosition = (position + xDelta).clamped(to: initialPosition ... successPosition)
            position = newXPosition
            gestureRecognizer.setTranslation(CGPoint.zero, in: parent)
        case .ended, .cancelled:
            if position >= successPosition {
                sendActions(for: .primaryActionTriggered)
            } else {
                animateToInitialPosition(from: position)
            }
        default: return
        }
    }

    private func animateToInitialPosition(from: CGFloat) {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = from
        animation.toValue = initialPosition

        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.fillMode = .backwards

        layer.add(animation, forKey: nil)
        position = initialPosition
    }
//
//    func animateSuccess() {
//        let background = CABasicAnimation(keyPath: "backgroundColor")
//        background.fromValue = UIHelper.brand.cgColor
//        background.toValue = layer.backgroundColor
//
//        let scale = CABasicAnimation(keyPath: "transform.scale")
//        scale.fromValue = 1.0
//        scale.toValue = CGFloat.r2 / CGFloat.r1
//
//        let group = CAAnimationGroup()
//        group.autoreverses = true
//        group.repeatCount = 1
//        group.duration = 0.1
//        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        group.fillMode = .backwards
//        group.animations = [background, scale]
//
//        layer.add(group, forKey: nil)
//    }
}

// MARK: - Dark mode
extension Swiper {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        layer.backgroundColor = EventCell.pinColor.cgColor
    }
}
