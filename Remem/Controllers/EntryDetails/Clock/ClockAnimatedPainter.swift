//
//  ClockAnimatedPainter.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.05.2022.
//

import UIKit

class ClockAnimatedPainter {
    // MARK: - Properties
    private let clockFace: ClockFace
    private let list: ClockSectionsList
    private let painter: ClockPainter

    // Getters
    private var bounds: CGRect { clockFace.bounds }
    private var center: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }
    private var displayedSections: [ClockSection] = []

    // MARK: - Init
    init(clockFace: ClockFace, sectionsList: ClockSectionsList) {
        self.clockFace = clockFace
        self.list = sectionsList
        self.painter = ClockPainter(rect: clockFace.bounds, sectionsList: sectionsList)
        addSectionsLayers()
    }
}

// MARK: - Public
extension ClockAnimatedPainter {
    func update() {
//        for index in 0 ... list.size - 1 {
//            guard let updatedSection = list.description(at: index) else { continue }
//            let displayedSection = displayedSections[index]
//
//            guard updatedSection != displayedSection else { continue }
//
//            updateColorIfNeeded(index: index, updatedSection: updatedSection)
//            updateLengthIfNeedeed(index: index, updatedSection: updatedSection)
//
//            updateDisplayedSectionWithUpdatedSection(index: index, updatedSection: updatedSection)
//        }
    }
}

// MARK: - Private
extension ClockAnimatedPainter {
    private func updateColorIfNeeded(index: Int, updatedSection: ClockSection) {
        let displayedSection = displayedSections[index]

        if color(for: displayedSection) != color(for: updatedSection) {
            addColorAnimation()
        }
    }

    private func updateLengthIfNeedeed(index: Int, updatedSection: ClockSection) {
        let displayedSection = displayedSections[index]
        if strokeEnd(for: displayedSection) != strokeEnd(for: updatedSection) {
            addLengthAnimation()
        }
    }

    private func addColorAnimation() {
        print(#function)
    }

    private func addLengthAnimation() {
        print(#function)
    }

    private func updateDisplayedSectionWithUpdatedSection(index: Int, updatedSection: ClockSection) {
        displayedSections[index] = updatedSection
    }

    private func addSectionsLayers() {
        for layer in makeLayers() {
            clockFace.layer.addSublayer(layer)
        }
    }

    private func makeLayers() -> [CAShapeLayer] {
        var result: [CAShapeLayer] = []

        for i in 0 ... list.size {
            guard let layer = makeLayer(at: i) else { continue }
            result.append(layer)
        }

        return result
    }

    private func makeLayer(at index: Int) -> CAShapeLayer? {
        guard let section = list.section(at: index) else { return nil }

        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.strokeColor = color(for: section).cgColor
        layer.strokeEnd = strokeEnd(for: section)
        layer.lineWidth = ClockPainter.sectionWidth
        layer.lineCap = .round

        let startOfSectionPoint = CGPoint(x: center.x, y: ClockPainter.sectionMaxHeight)
        let endOfSectionPoint = CGPoint(x: center.x, y: ClockPainter.sectionWidth / 2)
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
extension ClockAnimatedPainter {
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
