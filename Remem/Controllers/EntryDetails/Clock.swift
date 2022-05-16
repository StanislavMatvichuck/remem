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

    enum ClockVariant {
        case day
        case night
    }

    private static let maximumStitchHeight = 32.0
    private static let maximumFaceStitchHeight = 10.0
    private static let clockBoundsOffset = 0.0
    private static let faceOffset = 5.0

    // MARK: - Properties
    let variant: ClockVariant

    var leastDimension: CGFloat { min(bounds.width, bounds.height) }
    var stitchOuterRadius: CGFloat { center.y - Self.clockBoundsOffset }
    var stitchInnerRadius: CGFloat { stitchOuterRadius - Self.maximumStitchHeight }
    var faceInnerRadius: CGFloat { stitchInnerRadius - Self.maximumFaceStitchHeight - Self.faceOffset - 3.0 }

    var stitchVariantsArray: [StitchVariant] = {
        var array: [StitchVariant] = []
        for i in 0 ... 71 {
            array.append(StitchVariant(rawValue: Int.random(in: 0 ... 3))!)
        }
        return array
    }()

    // MARK: - Init
    init(for variant: ClockVariant) {
        self.variant = variant
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addLabels()
        addIcon()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        placeStitchesAround(in: context)
        placeFace(in: context)
    }

    private func placeStitchesAround(in context: CGContext) {
        let segmentAngle: CGFloat = 5

        for (index, angle) in stride(from: 0, through: 360 - segmentAngle, by: segmentAngle).enumerated() {
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
        let stitchWidth = 4.0
        let stitchHeight = stitchHeight(for: variant)

        let stitch = CGRect(x: center.x - stitchWidth / 2,
                            y: center.y - stitchOuterRadius + Self.maximumStitchHeight - stitchHeight,
                            width: stitchWidth,
                            height: stitchHeight)

        return UIBezierPath(roundedRect: stitch, cornerRadius: stitchWidth / 2)
    }

    private func stitchBackgroundColor(for variant: StitchVariant) -> CGColor {
        switch variant {
        case .empty: return UIColor.secondarySystemBackground.cgColor
        case .little: return UIColor.systemBlue.cgColor
        case .mid: return UIColor.systemBlue.cgColor
        case .big: return UIColor.systemBlue.cgColor
        }
    }

    private func stitchHeight(for variant: StitchVariant) -> CGFloat {
        switch variant {
        case .empty: return Self.maximumStitchHeight * 0.33
        case .little: return Self.maximumStitchHeight * 0.33
        case .mid: return Self.maximumStitchHeight * 0.66
        case .big: return Self.maximumStitchHeight
        }
    }

    private func placeFace(in context: CGContext) {
        let segmentAngle: CGFloat = 15

        for (index, angle) in stride(from: 0, through: 360 - segmentAngle, by: segmentAngle).enumerated() {
            let path = makeFaceStitch(isHour: index % 2 == 0 || index == 0)

            path.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
            path.apply(CGAffineTransform(rotationAngle: angle * .pi / 180))
            path.apply(CGAffineTransform(translationX: center.x, y: center.y))

            context.addPath(path.cgPath)
            context.setFillColor(UIColor.black.cgColor)
            context.fillPath(using: .winding)
        }
    }

    private func makeFaceStitch(isHour: Bool) -> UIBezierPath {
        let stitchWidth = 1.0
        let stitchHeight = isHour ? Self.maximumFaceStitchHeight : Self.maximumFaceStitchHeight / 2

        let stitch = CGRect(x: center.x - stitchWidth / 2,
                            y: center.y - stitchInnerRadius + Self.faceOffset,
                            width: stitchWidth,
                            height: stitchHeight)

        return UIBezierPath(roundedRect: stitch, cornerRadius: stitchWidth / 2)
    }

    override func layoutSubviews() {
        NSLayoutConstraint.activate([
            subviews[1].trailingAnchor.constraint(equalTo: centerXAnchor, constant: faceInnerRadius),
            subviews[3].leadingAnchor.constraint(equalTo: centerXAnchor, constant: -faceInnerRadius),
        ])

        super.layoutSubviews()
    }
}

// MARK: - Public
extension Clock {
    func update(stitches: [StitchVariant]) {
        stitchVariantsArray = stitches
        setNeedsDisplay()
    }
}

// MARK: - Private
extension Clock {
    private func addLabels() {
        let label12 = makeLabel(variant == .day ? "12" : "00")
        let label15 = makeLabel(variant == .day ? "15" : "03")
        let label18 = makeLabel(variant == .day ? "18" : "06")
        let label21 = makeLabel(variant == .day ? "21" : "09")

        addSubview(label12)
        addSubview(label15)
        addSubview(label18)
        addSubview(label21)

        let verticalOffset = center.y - faceInnerRadius

        NSLayoutConstraint.activate([
            label12.centerXAnchor.constraint(equalTo: centerXAnchor),
            label12.topAnchor.constraint(equalTo: topAnchor, constant: verticalOffset),

            label15.centerYAnchor.constraint(equalTo: centerYAnchor),

            label18.centerXAnchor.constraint(equalTo: centerXAnchor),
            label18.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalOffset),

            label21.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = .systemFont(ofSize: 0.8 * .font1)
        return label
    }

    private func addIcon() {
        let imageView = UIImageView(image: makeIcon())
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func makeIcon() -> UIImage {
        let imageName: String = {
            if variant == .day { return "sun.max" }
            else { return "moon.stars" }
        }()

        let image = UIImage(systemName: imageName)?
            .withTintColor(.secondarySystemBackground)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))

        return image!
    }
}
