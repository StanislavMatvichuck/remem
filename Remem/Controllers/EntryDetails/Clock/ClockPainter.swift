//
//  ClockPainter.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class ClockPainter {
    private static let maximumStitchHeight = 32.0
    private static let maximumFaceStitchHeight = 10.0
    private static let clockBoundsOffset = 0.0
    private static let faceOffset = 5.0

    // MARK: - Properties
    private var center: CGPoint { CGPoint(x: rect.midX, y: rect.midY) }
    private var leastDimension: CGFloat { min(rect.width, rect.height) }
    private var stitchOuterRadius: CGFloat { center.y - Self.clockBoundsOffset }
    private var stitchInnerRadius: CGFloat { stitchOuterRadius - Self.maximumStitchHeight }
    var faceInnerRadius: CGFloat { stitchInnerRadius - Self.maximumFaceStitchHeight - Self.faceOffset - 3.0 }

    private var context: CGContext?
    private let rect: CGRect
    private let list: ClockSectionDescriptionsList

    init(rect: CGRect, sectionsList: ClockSectionDescriptionsList) {
        self.rect = rect
        self.list = sectionsList
    }
}

// MARK: - Public
extension ClockPainter {
    func draw(in context: CGContext) {
        self.context = context
        placeStitchesAround()
        placeFace()
    }
}

// MARK: - Private
extension ClockPainter {
    private func placeStitchesAround() {
        let segmentAngle: CGFloat = 5

        for (index, angle) in stride(from: 0, through: 360 - segmentAngle, by: segmentAngle).enumerated() {
            guard let section = list.description(at: index) else { continue }

            let path = makeStitchPath(for: section)

            path.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
            path.apply(CGAffineTransform(rotationAngle: angle * .pi / 180))
            path.apply(CGAffineTransform(translationX: center.x, y: center.y))

            context?.addPath(path.cgPath)
            context?.setFillColor(color(for: section))
            context?.fillPath(using: .winding)
        }
    }

    private func placeFace() {
        let segmentAngle: CGFloat = 15

        for (index, angle) in stride(from: 0, through: 360 - segmentAngle, by: segmentAngle).enumerated() {
            let path = makeFaceStitch(isHour: index % 2 == 0 || index == 0)

            path.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
            path.apply(CGAffineTransform(rotationAngle: angle * .pi / 180))
            path.apply(CGAffineTransform(translationX: center.x, y: center.y))

            context?.addPath(path.cgPath)
            context?.setFillColor(UIColor.black.cgColor)
            context?.fillPath(using: .winding)
        }
    }

    private func makeStitchPath(for section: ClockSectionDescription) -> UIBezierPath {
        let stitchWidth = 4.0
        let stitchHeight = height(for: section)

        let stitch = CGRect(x: center.x - stitchWidth / 2,
                            y: center.y - stitchOuterRadius + Self.maximumStitchHeight - stitchHeight,
                            width: stitchWidth,
                            height: stitchHeight)

        return UIBezierPath(roundedRect: stitch, cornerRadius: stitchWidth / 2)
    }

    private func color(for section: ClockSectionDescription) -> CGColor {
        if section.hasFreshPoint { return UIColor.systemOrange.cgColor }

        switch section.variant {
        case .empty: return UIColor.secondarySystemBackground.cgColor
        case .little: return UIColor.systemBlue.cgColor
        case .mid: return UIColor.systemBlue.cgColor
        case .big: return UIColor.systemBlue.cgColor
        }
    }

    private func height(for section: ClockSectionDescription) -> CGFloat {
        switch section.variant {
        case .empty: return Self.maximumStitchHeight * 0.33
        case .little: return Self.maximumStitchHeight * 0.33
        case .mid: return Self.maximumStitchHeight * 0.66
        case .big: return Self.maximumStitchHeight
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
}
