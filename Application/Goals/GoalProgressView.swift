//
//  GoalProgressView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2024.
//

import UIKit

final class GoalProgressView: UIView {
    private static let start = CGFloat.pi / -2
    private static let end = CGFloat.pi * 3 / 2

    private var circleConfigured = false
    private lazy var circle: CAShapeLayer = {
        let w = self.bounds.width
        let h = self.bounds.height
        let layer = CAShapeLayer()

        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: w / 2.0, y: h / 2.0),
            radius: w / 2,
            startAngle: GoalProgressView.start,
            endAngle: GoalProgressView.end,
            clockwise: true
        )

        layer.path = circularPath.cgPath
        layer.lineCap = .round
        layer.lineWidth = .buttonMargin / 2
        layer.strokeEnd = 0.9
        layer.strokeColor = UIColor.bg.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    let percent = UILabel(al: true)

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
        configureContent()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCircleIfNeeded()
    }

    // MARK: - Private
    private func configureLayout() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        addSubview(percent)
        percent.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        percent.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    private func configureAppearance() {
        percent.font = .font
        percent.textColor = .bg
    }

    private func configureContent() {
        percent.text = "90%"
    }

    private func configureCircleIfNeeded() {
        guard circleConfigured == false else { return }
        layer.addSublayer(circle)
        circleConfigured = true
    }
}
