//
//  ClockSectionAnimatedLayer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.06.2022.
//

import UIKit

class ClockSectionAnimatedLayer: CAShapeLayer {
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
        lineWidth = ClockPainter.sectionWidth
        lineCap = .round
        path = path().cgPath
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension ClockSectionAnimatedLayer {
    func configure(for section: ClockSection) {
        strokeColor = Self.color(for: section).cgColor
        strokeEnd = Self.strokeEnd(for: section)
        opacity = Self.opacity(for: section)
    }

    func rotate(for index: Int) {
        let angle = (5.0 * CGFloat(index) * CGFloat.pi) / 180.0 // calculate angle
        transform = CATransform3DMakeRotation(angle, 0, 0, 1)
    }

    static func strokeEnd(for section: ClockSection) -> CGFloat {
        switch section.variant {
        case .empty: return 0.2
        case .little: return 0.33
        case .mid: return 0.66
        case .big: return 1.0
        }
    }

    static func color(for section: ClockSection) -> UIColor {
        if section.hasFreshPoint {
            return UIHelper.secondary
        }

        switch section.variant {
        case .empty:
            return UIHelper.clockSectionBackground
        case .little, .mid, .big:
            return UIHelper.brand
        }
    }

    static func opacity(for section: ClockSection) -> Float {
        if section.variant == .empty { return 1.0 }

        return section.isToday ? 1.0 : 0.3
    }
}

extension ClockSectionAnimatedLayer {
    private func path() -> UIBezierPath {
        let sectionWidthCompensation = ClockPainter.sectionWidth / 2
        let startOfSectionPoint = CGPoint(x: center.x, y: ClockPainter.sectionMaxHeight - sectionWidthCompensation)
        let endOfSectionPoint = CGPoint(x: center.x, y: sectionWidthCompensation)
        let start = UIBezierPath()

        start.move(to: startOfSectionPoint)
        start.addLine(to: endOfSectionPoint)

        return start
    }
}
