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
    private var layers: [ClockSectionAnimatedLayer] = []

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
            updateOpacityIfNeeded(at: index, updatedSection: section)
        }

        list = newList
    }
}

// MARK: - Private
extension ClockSectionsAnimator {
    private func installSections() {
        clockFace.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        layers.forEach { clockFace.layer.addSublayer($0) }
    }

    private func makeLayers(for sectionsList: ClockSectionsList) -> [ClockSectionAnimatedLayer] {
        sectionsList.sections.enumerated().map { makeLayer(at: $0, for: $1) }
    }

    private func makeLayer(at index: Int, for section: ClockSection) -> ClockSectionAnimatedLayer {
        let layer = ClockSectionAnimatedLayer(frame: clockFace.bounds)

        layer.frame = clockFace.bounds
        layer.configure(for: section)
        layer.rotate(for: index)

        return layer
    }

    private func updateColorIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list.section(at: index) else { return }

        let displayedColor = ClockSectionAnimatedLayer.color(for: displayedSection)
        let newColor = ClockSectionAnimatedLayer.color(for: updatedSection)

        if displayedColor != newColor {
            addColorAnimation(at: index, from: displayedColor, to: newColor)
        }
    }

    private func updateOpacityIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list.section(at: index) else { return }

        let displayedOpacity = ClockSectionAnimatedLayer.opacity(for: displayedSection)
        let newOpacity = ClockSectionAnimatedLayer.opacity(for: updatedSection)

        if displayedOpacity != newOpacity {
            addOpacityAnimation(at: index, from: displayedOpacity, to: newOpacity)
        }
    }

    private func updateStrokeEndIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list.section(at: index) else { return }

        let displayedStrokeEnd = ClockSectionAnimatedLayer.strokeEnd(for: displayedSection)
        let newStrokeEnd = ClockSectionAnimatedLayer.strokeEnd(for: updatedSection)

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

    private func addOpacityAnimation(at index: Int, from: Float, to: Float) {
        let layer = layers[index]

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.1
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .backwards
        animation.beginTime = CACurrentMediaTime() + Double(index) * 0.5 / 72

        layer.opacity = to
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
}
