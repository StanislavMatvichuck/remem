//
//  ClockAnimatedPainter.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.05.2022.
//

import UIKit

class ClockSectionsAnimator {
    // MARK: - Properties
    private let variant: ClockController.ClockVariant

    private var list: ClockSectionsList?
    private var layers: [ClockSectionAnimatedLayer] = []
    private var bounds: CGRect?

    // MARK: - Init
    init(variant: ClockController.ClockVariant) {
        self.variant = variant
    }
}

// MARK: - Public
extension ClockSectionsAnimator {
    func show(_ points: [Point]) {
        let newSections = makeList(for: points)
        update(newList: newSections)
    }

    func installSections(in view: UIView) {
        bounds = view.bounds

        view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let newList = ClockSectionsList.makeForClockVariant(variant, freshPoint: nil)
        let newLayers = makeLayers(for: newList)

        list = newList
        layers = newLayers
        layers.forEach { view.layer.addSublayer($0) }
    }
}

// MARK: - Private
extension ClockSectionsAnimator {
    private func update(newList: ClockSectionsList) {
        guard
            let list = list,
            newList.size == list.size
        else { fatalError("must be same size") }

        for (index, section) in newList.sections.enumerated() {
            updateColorIfNeeded(at: index, updatedSection: section)
            updateStrokeEndIfNeeded(at: index, updatedSection: section)
            updateOpacityIfNeeded(at: index, updatedSection: section)
        }

        self.list = newList
    }

    private func makeList(for points: [Point]) -> ClockSectionsList {
        var list = ClockSectionsList.makeForClockVariant(variant, freshPoint: nil)
        list.fill(with: points)
        return list
    }

    private func makeLayers(for sectionsList: ClockSectionsList) -> [ClockSectionAnimatedLayer] {
        var layers: [ClockSectionAnimatedLayer] = []
        sectionsList.sections.enumerated().forEach {
            if let layer = makeLayer(at: $0, for: $1) { layers.append(layer) }
        }
        return layers
    }

    private func makeLayer(at index: Int, for section: ClockSection) -> ClockSectionAnimatedLayer? {
        guard let bounds = bounds else { return nil }
        let layer = ClockSectionAnimatedLayer(frame: bounds)
        layer.frame = bounds
        layer.configure(for: section)
        layer.rotate(for: index)
        return layer
    }

    private func updateColorIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list?.section(at: index) else { return }

        let displayedColor = ClockSectionAnimatedLayer.color(for: displayedSection)
        let newColor = ClockSectionAnimatedLayer.color(for: updatedSection)

        if displayedColor != newColor {
            addColorAnimation(at: index, from: displayedColor, to: newColor)
        }
    }

    private func updateOpacityIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list?.section(at: index) else { return }

        let displayedOpacity = ClockSectionAnimatedLayer.opacity(for: displayedSection)
        let newOpacity = ClockSectionAnimatedLayer.opacity(for: updatedSection)

        if displayedOpacity != newOpacity {
            addOpacityAnimation(at: index, from: displayedOpacity, to: newOpacity)
        }
    }

    private func updateStrokeEndIfNeeded(at index: Int, updatedSection: ClockSection) {
        guard let displayedSection = list?.section(at: index) else { return }

        let displayedStrokeEnd = ClockSectionAnimatedLayer.strokeEnd(for: displayedSection)
        let newStrokeEnd = ClockSectionAnimatedLayer.strokeEnd(for: updatedSection)

        if displayedStrokeEnd != newStrokeEnd {
            addStrokeEndAnimation(at: index, from: displayedStrokeEnd, to: newStrokeEnd)
        }
    }

    private func layer(at index: Int) -> ClockSectionAnimatedLayer? {
        guard
            index < layers.count,
            index >= 0
        else { return nil }

        return layers[index]
    }

    private func addColorAnimation(at index: Int, from: UIColor, to: UIColor) {
        guard let layer = layer(at: index) else { return }

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
        guard let layer = layer(at: index) else { return }

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
        guard let layer = layer(at: index) else { return }

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
