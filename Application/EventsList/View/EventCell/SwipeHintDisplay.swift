//
//  SwipeHintDisplay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.04.2022.
//

import UIKit

final class SwipeHintDisplay: UIView {
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
        let image = UIImage.finger
            .withTintColor(.remem_secondary.withAlphaComponent(1.0))
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
        print(#function)
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    private var animationRequired = true

    override func layoutSubviews() {
        print(#function)
        super.layoutSubviews()
        configureCircleAppearance()
        startAnimation()
    }

    // MARK: - Private

    private func configureLayout() {
        addSubview(circle)
        circle.addSubview(finger)

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

    private func configureCircleAppearance() {
        circle.layer.backgroundColor = UIColor.remem_secondary.withAlphaComponent(0.1).cgColor
        circle.layer.cornerRadius = circle.bounds.width / 2
    }

    func startAnimation() {
        guard animationRequired else { return }
        animationRequired = false

        UIView.animate(withDuration: duration, animations: {
            let animation = CABasicAnimation.positionX
            animation.fromValue = self.initialConstant
            animation.toValue = self.finalConstant
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animation.autoreverses = true
            animation.duration = self.duration
            animation.repeatCount = 100
            self.circle.layer.add(animation, forKey: nil)
        })
    }
}
