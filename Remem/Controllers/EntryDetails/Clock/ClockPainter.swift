//
//  ClockPainter.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class ClockPainter {
    // Outer sections
    static let sectionMaxHeight = 33.0
    static let sectionWidth = 4.0
    static var drawsSections = true
    private static let sectionCornerRadius = sectionWidth / 2
    // Face sections
    private static let faceSectionWidth = 4.0
    private static let hoursFaceHeight = 12.0
    private static let minutesFaceHeight = 6.0
    private static let faceSectionCornerRadius = faceSectionWidth / 2
    private static let faceSectionOffset = 4.0
    // Arrows
    private static let arrowWidth = 5.0
    private static let arrowCornerRadius = arrowWidth / 2
    private static let arrowCenterOffset = 10.0

    private static let totalMinutes = 12 * 60

    private static let faceColor = UIColor.secondarySystemBackground
    private static let arrowColor = UIColor.systemBlue

    // Sections
    private var list: ClockSectionsList = .makeForDayClock()

    // MARK: - Properties
    private var bounds: CGRect?
    private var center: CGPoint { CGPoint(x: bounds?.midX ?? 0, y: bounds?.midY ?? 0) }
    private var minutesArrowHeight: CGFloat { faceLabelsRadius() - Self.faceSectionOffset }
    private var hoursArrowHeight: CGFloat { 0.6 * minutesArrowHeight }

    private var context: CGContext?
}

// MARK: - Public
extension ClockPainter {
    func draw(in context: CGContext, frame: CGRect) {
        self.context = context
        bounds = frame

        drawFace()
        drawArrows()
        drawSections()
    }

    func faceLabelsRadius() -> CGFloat {
        center.y - Self.sectionMaxHeight - Self.hoursFaceHeight - Self.faceSectionOffset
    }

    static func faceLabelsRadius(for rect: CGRect) -> CGFloat {
        rect.midY - Self.sectionMaxHeight - Self.hoursFaceHeight - Self.faceSectionOffset
    }
}

// MARK: - Private

extension ClockPainter {
    //
    // Sections
    //

    private func drawSections() {
        guard Self.drawsSections else { return }

        let segmentAngle: CGFloat = 5

        for (index, angle) in stride(from: 0, through: 360 - segmentAngle, by: segmentAngle).enumerated() {
            guard let section = list.section(at: index) else { continue }

            let path = makeSection(for: section)

            rotate(path, by: angle)
            fill(path, with: color(for: section))
        }
    }

    private func makeSection(for section: ClockSection) -> UIBezierPath {
        let height = height(for: section)
        let offset = Self.sectionMaxHeight - height

        return centeredRect(width: Self.sectionWidth,
                            height: height,
                            topOffset: offset,
                            cornerRadius: Self.sectionCornerRadius)
    }

    private func color(for section: ClockSection) -> UIColor {
        if section.hasFreshPoint {
            return UIColor.systemOrange
        }

        switch section.variant {
        case .empty:
            return UIColor.secondarySystemBackground
        case .little, .mid, .big:
            return UIColor.systemBlue
        }
    }

    private func height(for section: ClockSection) -> CGFloat {
        switch section.variant {
        case .empty: return Self.sectionMaxHeight * 0.2 + Self.sectionWidth
        case .little: return Self.sectionMaxHeight * 0.33
        case .mid: return Self.sectionMaxHeight * 0.66
        case .big: return Self.sectionMaxHeight
        }
    }

    //
    // Face
    //

    private func drawFace() {
        let segmentAngle: CGFloat = 15

        for (index, angle) in stride(from: 0, through: 360 - segmentAngle, by: segmentAngle).enumerated() {
            let path = makeFaceSection(isHour: index % 2 == 0 || index == 0)
            rotate(path, by: angle)
            fill(path, with: Self.faceColor)
        }
    }

    private func makeFaceSection(isHour: Bool) -> UIBezierPath {
        let offset = Self.sectionMaxHeight + Self.faceSectionOffset
        let height = isHour ? Self.hoursFaceHeight : Self.minutesFaceHeight

        return centeredRect(width: Self.faceSectionWidth,
                            height: height,
                            topOffset: offset,
                            cornerRadius: Self.faceSectionCornerRadius)
    }

    //
    // Arrows
    //

    private func drawArrows() {
        drawHoursArrow()
        drawMinutesArrow()
        drawArrowsCenter()
    }

    private func drawHoursArrow() {
        let angle = CGFloat(360 * currentHoursAsMinutes / Self.totalMinutes)
        paintArrow(height: hoursArrowHeight, and: angle)
    }

    private func drawMinutesArrow() {
        let angle = CGFloat(360 * currentMinutes / 60)
        paintArrow(height: minutesArrowHeight, and: angle)
    }

    private func paintArrow(height: CGFloat, and angle: CGFloat) {
        let offset = center.y - height
        let path = centeredRect(width: Self.arrowWidth,
                                height: height - Self.arrowCenterOffset,
                                topOffset: offset,
                                cornerRadius: Self.arrowCornerRadius)

        rotate(path, by: angle)
        fill(path, with: Self.faceColor)
        stroke(path: path)

        drawArrowSupportLine(with: angle)
    }

    private func drawArrowSupportLine(with angle: CGFloat) {
        let centerPath = UIBezierPath()
        centerPath.move(to: center)
        centerPath.addLine(to: CGPoint(x: center.x, y: center.y - Self.arrowCenterOffset))
        centerPath.close()

        rotate(centerPath, by: angle)
        stroke(path: centerPath)
    }

    private func drawArrowsCenter() {
        let circle = UIBezierPath(ovalIn: CGRect(x: center.x - 2.5, y: center.y - 2.5, width: 5, height: 5))

        fill(circle, with: .systemBackground)
        stroke(path: circle)
    }

    var currentHoursAsMinutes: Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date.now)
        let hoursToMinutes = (components.hour ?? 0) * 60
        let minutes = components.minute ?? 0
        return hoursToMinutes + minutes
    }

    var currentMinutes: Int {
        return Calendar.current.dateComponents([.hour, .minute], from: Date.now).minute ?? 0
    }

    private func stroke(path: UIBezierPath) {
        context?.addPath(path.cgPath)
        context?.setStrokeColor(Self.arrowColor.cgColor)
        context?.setLineWidth(2)
        context?.strokePath()
    }

    //
    // Common methods
    //

    private func centeredRect(width: CGFloat, height: CGFloat, topOffset: CGFloat = 0.0, cornerRadius: CGFloat) -> UIBezierPath {
        let rect = CGRect(x: center.x - width / 2, y: topOffset, width: width, height: height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        return path
    }

    private func rotate(_ path: UIBezierPath, by angle: CGFloat) {
        path.apply(CGAffineTransform(translationX: -center.x, y: -center.y))
        path.apply(CGAffineTransform(rotationAngle: angle * .pi / 180))
        path.apply(CGAffineTransform(translationX: center.x, y: center.y))
    }

    private func fill(_ path: UIBezierPath, with color: UIColor = UIColor.secondarySystemBackground) {
        context?.addPath(path.cgPath)
        context?.setFillColor(color.cgColor)
        context?.fillPath(using: .winding)
    }
}
