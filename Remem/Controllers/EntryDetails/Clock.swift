//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

class Clock: UIView {
    enum StitchVariant: Int {
        case empty
        case little
        case mid
        case big
    }

    // MARK: - Properties
    let maximumStitchHeight = 32.0
    var circleMarginFromBounds: CGFloat = 0.0
    var leastDimension: CGFloat { min(bounds.width, bounds.height) }

    var stitchVariantsArray: [StitchVariant] = {
        var array: [StitchVariant] = []
        for i in 0 ... 71 {
            array.append(StitchVariant(rawValue: Int.random(in: 0 ... 3))!)
        }
        return array
    }()

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
        guard let context = UIGraphicsGetCurrentContext() else { return }
        placeStitchesAround(in: context)
    }

    private func placeStitchesAround(in context: CGContext) {
        let toothAngle: CGFloat = 5

        for (index, angle) in stride(from: toothAngle, through: 360, by: toothAngle).enumerated() {
            let stitchVariant = stitchVariantsArray[index]
            let path = makeStitchPath(for: stitchVariant)

            path.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
            path.apply(CGAffineTransform(rotationAngle: angle * .pi / 180))
            path.apply(CGAffineTransform(translationX: center.x, y: center.y))

            context.addPath(path.cgPath)
            context.setFillColor(stitchBackgroundColor(for: stitchVariant))
            context.fillPath(using: .winding)
        }
    }

    private func makeStitchPath(for variant: StitchVariant) -> UIBezierPath {
        let radius = (leastDimension / 2.0) - circleMarginFromBounds - maximumStitchHeight
        let stitchWidth = 4.0
        let stitchHeight = stitchHeight(for: variant)

        let stitch = CGRect(x: center.x - stitchWidth / 2,
                            y: center.y - stitchHeight - radius,
                            width: stitchWidth,
                            height: stitchHeight)

        return UIBezierPath(roundedRect: stitch, cornerRadius: stitchWidth / 2)
    }

    private func stitchBackgroundColor(for variant: StitchVariant) -> CGColor {
        switch variant {
        case .empty: return UIColor.secondarySystemBackground.cgColor
        case .little: return UIColor.blue.cgColor
        case .mid: return UIColor.blue.cgColor
        case .big: return UIColor.blue.cgColor
        }
    }

    private func stitchHeight(for variant: StitchVariant) -> CGFloat {
        switch variant {
        case .empty: return maximumStitchHeight * 0.33
        case .little: return maximumStitchHeight * 0.33
        case .mid: return maximumStitchHeight * 0.66
        case .big: return maximumStitchHeight
        }
    }

    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            subviews[1].centerXAnchor.constraint(equalTo: centerXAnchor, constant: (leastDimension - maximumStitchHeight / 2) / 2),
            subviews[3].centerXAnchor.constraint(equalTo: centerXAnchor, constant: (leastDimension - maximumStitchHeight / 2) / -2),
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
