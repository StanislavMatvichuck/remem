//
//  EventCellGoalIndicator.swift
//  Application
//
//  Created by Stanislav Matvichuck on 21.04.2024.
//

import UIKit

final class EventCellGoalIndicator: UIView {
    private static let width = CGFloat.buttonMargin + 1

    var viewModel: GoalViewModel? { didSet {
        guard let viewModel else { isHidden = true; return }
        isHidden = false
        if circlesConfigured {
            configureAppearance()
        }
    }}

    private var circlesConfigured = false
    private lazy var circle: CAShapeLayer = {
        if let viewModel {
            let color = viewModel.isAchieved ?
                UIColor.bg_goal_achieved :
                UIColor.border_secondary
            return makeCircle(color: color, progress: viewModel.progress)
        } else {
            return makeCircle(color: .border_secondary, progress: 0)
        }
    }()

    private lazy var permanentCircle = makeCircle(color: .border, progress: 1.0)

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = false
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
        /// Dark mode fix for CAShapeLayer
        if #available(iOS 17.0, *) { registerForTraitChanges([UITraitUserInterfaceStyle.self], target: self, action: #selector(configureAppearance)) }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureCircleIfNeeded()
    }

    @objc private func configureAppearance() {
        guard let viewModel else { return }
        circle.strokeEnd = viewModel.progress
        circle.strokeColor = viewModel.isAchieved ?
            UIColor.bg_goal_achieved.cgColor :
            UIColor.border_secondary.cgColor

        permanentCircle.strokeColor = UIColor.border.cgColor
    }

    private func configureCircleIfNeeded() {
        guard circlesConfigured == false else { return }
        layer.addSublayer(permanentCircle)
        layer.addSublayer(circle)
        circlesConfigured = true
    }

    private func makeCircle(color: UIColor, progress: CGFloat) -> CAShapeLayer {
        let w = self.bounds.width
        let h = self.bounds.height
        let layer = CAShapeLayer()
        layer.lineCap = .round
        layer.lineWidth = Self.width
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeStart = 0
        layer.path = UIBezierPath(
            arcCenter: CGPoint(x: w / 2.0, y: h / 2.0),
            radius: w / 2,
            startAngle: GoalProgressView.start,
            endAngle: GoalProgressView.end,
            clockwise: true
        ).cgPath

        layer.strokeEnd = progress
        layer.strokeColor = color.cgColor

        return layer
    }
}
