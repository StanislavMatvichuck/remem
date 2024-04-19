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
    private static let width: CGFloat = 2 * .buttonMargin

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
        layer.lineWidth = Self.width
        layer.strokeStart = 0
        if let viewModel {
            layer.strokeEnd = viewModel.progress
            layer.strokeColor = viewModel.isAchieved ?
                UIColor.text_goalAchieved.cgColor :
                UIColor.border_secondary.cgColor
        }
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    private lazy var permanentCircle: CAShapeLayer = {
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
        layer.lineWidth = Self.width
        layer.strokeStart = 0
        layer.strokeEnd = 1
        layer.strokeColor = UIColor.bg_secondary_dimmed.cgColor
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()

    var viewModel: GoalViewModel? { didSet {
        guard let viewModel else { return }
        percent.text = viewModel.readablePercent
        happenings.text = viewModel.readableHappenings
        value.text = viewModel.readableValue
        if circleConfigured { circle.strokeEnd = viewModel.progress }
        percent.textColor = viewModel.isAchieved ? UIColor.text_goalAchieved : UIColor.border_secondary
        if circleConfigured {
            circle.strokeColor = viewModel.isAchieved ? UIColor.text_goalAchieved.cgColor : UIColor.border_secondary.cgColor
        }
    }}

    let percent = UILabel(al: true)
    let happenings = UILabel(al: true)
    let value = UILabel(al: true)

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
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

        addSubview(happenings)
        happenings.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        happenings.bottomAnchor.constraint(equalTo: percent.topAnchor).isActive = true

        addSubview(value)
        value.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        value.topAnchor.constraint(equalTo: percent.bottomAnchor).isActive = true
    }

    private func configureAppearance() {
        percent.font = .fontBoldBig
        percent.textColor = .border_secondary
        percent.adjustsFontSizeToFitWidth = true
        percent.minimumScaleFactor = 0.3

        happenings.font = .font
        happenings.textColor = .bg

        value.font = .font
        value.textColor = .bg
    }

    private func configureCircleIfNeeded() {
        guard circleConfigured == false else { return }
        layer.addSublayer(permanentCircle)
        layer.addSublayer(circle)
        circleConfigured = true
    }
}
