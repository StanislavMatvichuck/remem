//
//  WeekCellDayContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 09.05.2023.
//

import UIKit

final class WeekCellDayContainer: UIView {
    private static let spacing = CGFloat.buttonMargin / 8
    private static let width = CGFloat.layoutSquare - 2 * spacing
    private static let radius = spacing * 5

    private var dayShape: CAShapeLayer?
    private var fillColor: UIColor?
    private var borderColor: UIColor?

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func draw(_ rect: CGRect) {
        if dayShape == nil {
            let shape = makeSublayer()
            dayShape = shape
            layer.insertSublayer(shape, at: 0)
        }

        configureAppearance()
    }

    // MARK: - Public
    func set(fill: UIColor, border: UIColor) {
        fillColor = fill
        borderColor = border
    }

    func prepareForReuse() {
        dayShape?.removeFromSuperlayer()
        dayShape = nil
    }

    // MARK: - Private
    private func configureLayout() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Self.width),
            heightAnchor.constraint(equalToConstant: Self.width),
        ])
    }

    private func configureAppearance() {
        guard let dayShape, let fillColor, let borderColor else { return }
        dayShape.fillColor = fillColor.cgColor
        dayShape.strokeColor = borderColor.cgColor
    }

    private func makeSublayer() -> CAShapeLayer {
        let frame = CGRect(origin: .zero, size: CGSize(width: Self.width, height: Self.width))
        let path = makePath()

        let layer = CAShapeLayer()
        layer.frame = frame
        layer.lineWidth = .border
        layer.path = path.cgPath
        return layer
    }

    private func makePath() -> UIBezierPath {
        let width = Self.width
        let radius = Self.radius
        let center = width / 2
        let bottomCutWidth = width * 0.67
        let bottomLeftCornerX = center - bottomCutWidth / 2
        let bottomRightCornerX = center + bottomCutWidth / 2

        let arcCenters = [
            CGPoint(x: width - radius, y: radius), // 0
            CGPoint(x: width - radius, y: width - radius), // 1
            CGPoint(x: bottomRightCornerX - radius, y: width), // 2
            CGPoint(x: bottomLeftCornerX + radius, y: width), // 3
            CGPoint(x: radius, y: width - radius), // 4
            CGPoint(x: radius, y: radius), // 5
        ]

        let linePins = [
            CGPoint(x: radius, y: 0), // 0
            CGPoint(x: width - radius, y: 0), // 1
            CGPoint(x: width, y: width - radius), // 2
            CGPoint(x: bottomRightCornerX, y: width), // 3
            CGPoint(x: bottomLeftCornerX + radius, y: width - radius), // 4
            CGPoint(x: radius, y: width), // 5
            CGPoint(x: 0, y: radius), // 6
        ]
        let path = UIBezierPath()
        path.move(to: linePins[0])
        path.addLine(to: linePins[1])
        path.addArc(withCenter: arcCenters[0], radius: radius, startAngle: .pi * 3 / 2, endAngle: 0, clockwise: true)
        path.addLine(to: linePins[2])
        path.addArc(withCenter: arcCenters[1], radius: radius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
        path.addLine(to: linePins[3])
        path.addArc(withCenter: arcCenters[2], radius: radius, startAngle: 0, endAngle: .pi * 3 / 2, clockwise: false)
        path.addLine(to: linePins[4])
        path.addArc(withCenter: arcCenters[3], radius: radius, startAngle: .pi * 3 / 2, endAngle: .pi, clockwise: false)
        path.addLine(to: linePins[5])
        path.addArc(withCenter: arcCenters[4], radius: radius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
        path.addLine(to: linePins[6])
        path.addArc(withCenter: arcCenters[5], radius: radius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
        return path
    }

    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureAppearance()
    }
}
