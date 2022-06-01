//
//  ClockAnimatedPainter.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.05.2022.
//

import UIKit

struct ClockSectionsAnimator {
    // MARK: - Properties
    private let clockFace: UIView
    private var list: ClockSectionsList
    private var layers: [CAShapeLayer] = []
    // Getters
    private var bounds: CGRect { clockFace.bounds }
    private var center: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }

    // MARK: - Init
    init(clockFace: UIView, sectionsList: ClockSectionsList = .makeForDayClock()) {
        self.clockFace = clockFace
        self.list = sectionsList

        self.layers = makeLayers(for: list)
        installSections()
    }
}

// MARK: - Public
extension ClockSectionsAnimator {
    mutating func update(newList: ClockSectionsList) {
        guard newList.size == list.size else { fatalError("must be same size") }

        for (index, section) in newList.sections.enumerated() {
            updateColorIfNeeded(at: index, updatedSection: section)
            updateStrokeEndIfNeeded(at: index, updatedSection: section)
        }

        list = newList
    }
}

// MARK: - Private
extension ClockSectionsAnimator {
    private func updateColorIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list.section(at: index) else { return }

        let displayedColor = color(for: displayedSection)
        let newColor = color(for: updatedSection)

        if displayedColor != newColor {
            addColorAnimation(at: index, from: displayedColor, to: newColor)
        }
    }

    private func updateStrokeEndIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list.section(at: index) else { return }

        let displayedStrokeEnd = strokeEnd(for: displayedSection)
        let newStrokeEnd = strokeEnd(for: updatedSection)

        if displayedStrokeEnd != newStrokeEnd {
            addStrokeEndAnimation(at: index, from: displayedStrokeEnd, to: newStrokeEnd)
        }
    }

    private func addColorAnimation(at index: Int, from: UIColor, to: UIColor) {
        let layer = layers[index]

        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.duration = 0.1
        animation.fromValue = from.cgColor
        animation.toValue = to.cgColor
        animation.fillMode = .backwards
        animation.beginTime = CACurrentMediaTime() + Double(index) * 0.5 / 72

        layer.strokeColor = to.cgColor
        layer.add(animation, forKey: nil)
    }

    private func addStrokeEndAnimation(at index: Int, from: CGFloat, to: CGFloat) {
        let layer = layers[index]

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .backwards

        animation.beginTime = CACurrentMediaTime() + Double(index) * 0.5 / 72

        layer.strokeEnd = to
        layer.add(animation, forKey: nil)
    }

    private func installSections() {
        clockFace.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        layers.forEach { clockFace.layer.addSublayer($0) }
    }

    private func makeLayers(for sectionsList: ClockSectionsList) -> [CAShapeLayer] {
        sectionsList.sections.enumerated().map { makeLayer(at: $0, for: $1) }
    }

    private func makeLayer(at index: Int, for section: ClockSection) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.strokeColor = color(for: section).cgColor
        layer.strokeEnd = strokeEnd(for: section)
        layer.lineWidth = ClockPainter.sectionWidth
        layer.lineCap = .round

        let sectionWidthCompensation = ClockPainter.sectionWidth / 2
        let startOfSectionPoint = CGPoint(x: center.x, y: ClockPainter.sectionMaxHeight - sectionWidthCompensation)
        let endOfSectionPoint = CGPoint(x: center.x, y: sectionWidthCompensation)
        let start = UIBezierPath()

        start.move(to: startOfSectionPoint)
        start.addLine(to: endOfSectionPoint)

        layer.path = start.cgPath

        let angle = (5.0 * CGFloat(index) * CGFloat.pi) / 180.0 // calculate angle
        layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)

        return layer
    }
}

// MARK: - Private
extension ClockSectionsAnimator {
    private func strokeEnd(for section: ClockSection) -> CGFloat {
        switch section.variant {
        case .empty: return 0.2
        case .little: return 0.33
        case .mid: return 0.66
        case .big: return 1.0
        }
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
}
