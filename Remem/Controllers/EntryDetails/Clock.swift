//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

class Clock: UIView {
    // MARK: - Properties
    let lineWidth = 32.0
    var circleMarginFromBounds: CGFloat = 0.0
    var label15VerticalConstraint: NSLayoutConstraint!
    var leastDimension: CGFloat { min(bounds.width, bounds.height) }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addLabels()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = ((leastDimension - lineWidth / 2) / 2.0) - circleMarginFromBounds
        let toothAngle: CGFloat = 5
        let stitchWidth = 2.0
        let stitchHeight = lineWidth * 0.5

        var path = UIBezierPath()

        // Draw circle
//        path.move(to: CGPoint(x: center.x + radius, y: center.y))
//        path.addArc(
//            withCenter: CGPoint(x: center.x, y: center.y),
//            radius: radius,
//            startAngle: 0,
//            endAngle: 2 * .pi,
//            clockwise: true)
//
//        path.lineWidth = lineWidth
//        UIColor.secondarySystemBackground.set()
//        path.stroke()

        let stitch = CGRect(x: center.x - stitchWidth,
                            y: center.y - radius - stitchHeight / 2,
                            width: stitchWidth,
                            height: stitchHeight)

        path = UIBezierPath(roundedRect: stitch, cornerRadius: stitchWidth / 2)
        UIColor.blue.set()

        for _ in stride(from: toothAngle, through: 360, by: toothAngle) {
            // Move origin to center of the circle
            path.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
            // Rotate
            path.apply(CGAffineTransform(rotationAngle: toothAngle * .pi / 180))
            // Move origin back to original location
            path.apply(CGAffineTransform(translationX: center.x, y: center.y))

            path.fill()
        }
    }

    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            subviews[1].centerXAnchor.constraint(equalTo: centerXAnchor, constant: (leastDimension - lineWidth / 2) / 2),
            subviews[3].centerXAnchor.constraint(equalTo: centerXAnchor, constant: (leastDimension - lineWidth / 2) / -2),
        ])

        super.layoutSubviews()
        circleMarginFromBounds = subviews[0].bounds.height
    }
}

// MARK: - Private
extension Clock {
    private func addLabels() {
        let label12 = makeLabel("12")
        let label15 = makeLabel("15")
        let label18 = makeLabel("18")
        let label21 = makeLabel("21")

        addSubview(label12)
        addSubview(label15)
        addSubview(label18)
        addSubview(label21)
        NSLayoutConstraint.activate([
            label12.centerXAnchor.constraint(equalTo: centerXAnchor),
            label12.topAnchor.constraint(equalTo: topAnchor),

            label15.centerYAnchor.constraint(equalTo: centerYAnchor),

            label18.centerXAnchor.constraint(equalTo: centerXAnchor),
            label18.bottomAnchor.constraint(equalTo: bottomAnchor),

            label21.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = .systemFont(ofSize: .font1)
        return label
    }
}
