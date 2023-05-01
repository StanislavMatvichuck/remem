//
//  WeekAccessoryView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.04.2023.
//

import UIKit

final class WeekAccessoryView: UIView {
    var sublayer: CALayer?
    var leftDistance: CGFloat = .buttonMargin

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        print(rect)
        sublayer?.removeFromSuperlayer()
        sublayer = make()
        layer.addSublayer(sublayer!)
    }

    // MARK: - Private
    private func make() -> CALayer {
        let height = bounds.height
        let radius = height / 4
        let leftDistance = self.leftDistance - 4 * radius
        let width = bounds.width
        let arcsCenters = [
            CGPoint(x: 0, y: height / 2 + radius),
            CGPoint(x: 2 * radius, y: height / 2 + radius),
            CGPoint(x: 2 * radius + leftDistance, y: 0),
            CGPoint(x: 2 * radius + leftDistance + 4 * radius, y: 0),
            CGPoint(x: width - 2 * radius, y: height / 2 + radius),
            CGPoint(x: width, y: height / 2 + radius),
        ]

        let path = UIBezierPath()
        // left corner
        path.move(to: CGPoint(x: 0, y: height))
        path.addArc(
            withCenter: arcsCenters[0],
            radius: radius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: false
        )
        path.addArc(
            withCenter: arcsCenters[1],
            radius: radius,
            startAngle: -.pi,
            endAngle: -.pi / 2,
            clockwise: true
        )
        // left line
        path.addLine(to: CGPoint(x: 2 * radius + leftDistance, y: 2 * radius))
        // center
        path.addArc(
            withCenter: arcsCenters[2],
            radius: 2 * radius,
            startAngle: .pi / 2,
            endAngle: 0,
            clockwise: false
        )
        path.addArc(
            withCenter: arcsCenters[3],
            radius: 2 * radius,
            startAngle: .pi,
            endAngle: .pi / 2,
            clockwise: false
        )
        // right line
        path.addLine(to: CGPoint(x: width - 2 * radius, y: 2 * radius))
        // right corner
        path.addArc(
            withCenter: arcsCenters[4],
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 0,
            clockwise: true
        )
        path.addArc(
            withCenter: arcsCenters[5],
            radius: radius,
            startAngle: -.pi,
            endAngle: .pi / 2,
            clockwise: false
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.secondary.cgColor
        shapeLayer.fillColor = UIColor.background.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        return shapeLayer
    }
}
