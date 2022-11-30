//
//  ClockSectionAnimatedLayer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.06.2022.
//

import UIKit

class ClockSectionAnimatedLayer: CAShapeLayer {
    static let length = 48.0
    static let width = 3.0

    // MARK: - Properties
    var section: ClockSection!
    var center: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }

    // MARK: - Init
    init(section: ClockSection, frame: CGRect) {
        self.section = section
        super.init()
        self.frame = frame
        configureAppearance()
    }

    override init(layer: Any) { super.init(layer: layer) }

    private func configureAppearance() {
        lineWidth = Self.width
        lineCap = .round
        path = path().cgPath
        strokeColor = Self.color(for: section).cgColor
        strokeEnd = Self.strokeEnd(for: section)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension ClockSectionAnimatedLayer {
    func animate(at index: Int, to section: ClockSection) {
        updateColorIfNeeded(at: index, updatedSection: section)
        updateStrokeEndIfNeeded(at: index, updatedSection: section)
        rotate(for: index)
        self.section = section
    }

    func rotate(for index: Int) {
        let angleDegrees = 360.0 / CGFloat(ClockViewModel.size) * CGFloat(index)
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
        animation.beginTime = beginTime(for: index)

        strokeColor = to.cgColor
        add(animation, forKey: nil)
    }

    private func addOpacityAnimation(at index: Int, from: Float, to: Float) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.1
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .backwards
        animation.beginTime = beginTime(for: index)

        opacity = to
        add(animation, forKey: nil)
    }

    private func addStrokeEndAnimation(at index: Int, from: CGFloat, to: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .backwards

        animation.beginTime = beginTime(for: index)

        strokeEnd = to
        add(animation, forKey: nil)
    }

    private func beginTime(for index: Int) -> CFTimeInterval {
        return CACurrentMediaTime() + Double(index) * 0.5 / CGFloat(ClockViewModel.size)
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
        switch section.variant {
        case .empty:
            return UIHelper.clockSectionBackground
        case .little, .mid, .big:
            return UIHelper.brand
        }
    }
}
