//
//  SwipingCircleView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 09.05.2023.
//

import UIKit

final class SwipingCircleView: UIView {
    static let plusSize = CGFloat.buttonRadius / 5

    let circle: UIView = {
        let view = UIView(al: true)
        view.widthAnchor.constraint(equalToConstant: .swiperRadius * 2).isActive = true
        view.heightAnchor.constraint(equalToConstant: .swiperRadius * 2).isActive = true
        return view
    }()

    let plusLayer: CALayer = {
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

        plusLayer.strokeColor = UIColor.background_secondary.cgColor
        plusLayer.path = path.cgPath
        plusLayer.lineCap = .round
        plusLayer.lineWidth = 4.0
        return plusLayer
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        addSubview(circle)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: .buttonHeight),
            heightAnchor.constraint(equalToConstant: .buttonHeight),
            circle.centerXAnchor.constraint(equalTo: centerXAnchor),
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

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let plus = circle.layer.sublayers?.first as? CAShapeLayer {
            plus.strokeColor = UIColor.background_secondary.cgColor
        }
    }
}
