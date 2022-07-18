//
//  ClockSectionAnimatedLayer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.06.2022.
//

import UIKit

class ClockSectionAnimatedLayer: CAShapeLayer {
    static let length = 48.0
    static let width = 4.0

    // MARK: - Properties
    private var section = ClockSection(happeningsAmount: 0,
                                       hasFreshHappening: false,
                                       isToday: true)

    private var center: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }

    // MARK: - Init
    override init(layer: Any) {
        super.init(layer: layer)
        commonInit()
    }

    init(frame: CGRect) {
        super.init()
        self.frame = frame
        commonInit()
    }

    private func commonInit() {
        lineWidth = 4.0
        lineCap = .round
        path = path().cgPath
        strokeColor = Self.color(for: section).cgColor
        strokeEnd = Self.strokeEnd(for: section)
        opacity = Self.opacity(for: section)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension ClockSectionAnimatedLayer {
    func animate(at index: Int, to section: ClockSection) {
        updateColorIfNeeded(at: index, updatedSection: section)
        updateOpacityIfNeeded(at: index, updatedSection: section)
        updateStrokeEndIfNeeded(at: index, updatedSection: section)
        rotate(for: index)
        self.section = section
    }

    func rotate(for index: Int) {
        let angleDegrees = 360.0 / CGFloat(ClockSectionsList.size) * CGFloat(index)
        let angleRad = ((angleDegrees + 180.0) * CGFloat.pi) / 180.0
        transform = CATransform3DMakeRotation(angleRad, 0, 0, 1)
    }
}

// MARK: - Private
extension ClockSectionAnimatedLayer {
    private func path() -> UIBezierPath {
        // TODO: clock layout for different screen sizes
        let sectionWidth = Self.width
        let sectionMaxHeight = Self.length
        let sectionWidthCompensation = sectionWidth / 2
        let startOfSectionPoint = CGPoint(x: center.x, y: sectionMaxHeight - sectionWidthCompensation)
        let endOfSectionPoint = CGPoint(x: center.x, y: sectionWidthCompensation)
        let start = UIBezierPath()

        start.move(to: startOfSectionPoint)
        start.addLine(to: endOfSectionPoint)

        return start
    }

    private func updateColorIfNeeded(at index: Int, updatedSection: ClockSection) {
        let displayedColor = ClockSectionAnimatedLayer.color(for: section)
        let newColor = ClockSectionAnimatedLayer.color(for: updatedSection)

        if displayedColor != newColor {
            addColorAnimation(at: index, from: displayedColor, to: newColor)
        }
    }

    private func updateOpacityIfNeeded(at index: Int, updatedSection: ClockSection) {
        let displayedOpacity = ClockSectionAnimatedLayer.opacity(for: section)
        let newOpacity = ClockSectionAnimatedLayer.opacity(for: updatedSection)

        if displayedOpacity != newOpacity {
            addOpacityAnimation(at: index, from: displayedOpacity, to: newOpacity)
        }
    }

    private func updateStrokeEndIfNeeded(at index: Int, updatedSection: ClockSection) {
        let displayedStrokeEnd = ClockSectionAnimatedLayer.strokeEnd(for: section)
        let newStrokeEnd = ClockSectionAnimatedLayer.strokeEnd(for: updatedSection)

        if displayedStrokeEnd != newStrokeEnd {
            addStrokeEndAnimation(at: index, from: displayedStrokeEnd, to: newStrokeEnd)
        }
    }

    private func addColorAnimation(at index: Int, from: UIColor, to: UIColor) {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.duration = 0.1
        animation.fromValue = from.cgColor
        animation.toValue = to.cgColor
        animation.fillMode = .backwards
        animation.beginTime = CACurrentMediaTime() + Double(index) * 0.5 / 72

        strokeColor = to.cgColor
        add(animation, forKey: nil)
    }

    private func addOpacityAnimation(at index: Int, from: Float, to: Float) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.1
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .backwards
        animation.beginTime = CACurrentMediaTime() + Double(index) * 0.5 / 72

        opacity = to
        add(animation, forKey: nil)
    }

    private func addStrokeEndAnimation(at index: Int, from: CGFloat, to: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .backwards

        animation.beginTime = CACurrentMediaTime() + Double(index) * 0.5 / 72

        strokeEnd = to
        add(animation, forKey: nil)
    }

    // Static methods
    private static func strokeEnd(for section: ClockSection) -> CGFloat {
        switch section.variant {
        case .empty: return 0.2
        case .little: return 0.33
        case .mid: return 0.66
        case .big: return 1.0
        }
    }

    private static func color(for section: ClockSection) -> UIColor {
        if section.hasFreshHappening {
            return UIHelper.secondary
        }

        switch section.variant {
        case .empty:
            return UIHelper.clockSectionBackground
        case .little, .mid, .big:
            return UIHelper.brand
        }
    }

    private static func opacity(for section: ClockSection) -> Float {
        if section.variant == .empty { return 1.0 }

        return section.isToday ? 1.0 : 1.0
    }
}
