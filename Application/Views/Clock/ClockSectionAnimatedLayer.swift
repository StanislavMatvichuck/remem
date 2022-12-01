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
    var viewModel: ClockSectionViewModel!
    var center: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }
    var size: Int!

    // MARK: - Init
    init(section: ClockSectionViewModel, frame: CGRect, size: Int) {
        self.viewModel = section
        self.size = size
        super.init()
        self.frame = frame
        configureAppearance()
    }

    override init(layer: Any) { super.init(layer: layer) }

    private func configureAppearance() {
        lineWidth = Self.width
        lineCap = .round
        path = path().cgPath
        strokeColor = Self.color(for: viewModel).cgColor
        strokeEnd = Self.strokeEnd(for: viewModel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension ClockSectionAnimatedLayer {
    func animate(at index: Int, to viewModel: ClockSectionViewModel) {
        updateColorIfNeeded(at: index, updatedSection: viewModel)
        updateStrokeEndIfNeeded(at: index, updatedSection: viewModel)
        rotate(for: index)
        self.viewModel = viewModel
    }

    func rotate(for index: Int) {
        let angleDegrees = 360.0 / CGFloat(size) * CGFloat(index)
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

    private func updateColorIfNeeded(at index: Int, updatedSection: ClockSectionViewModel) {
        let displayedColor = ClockSectionAnimatedLayer.color(for: viewModel)
        let newColor = ClockSectionAnimatedLayer.color(for: updatedSection)

        if displayedColor != newColor {
            addColorAnimation(at: index, from: displayedColor, to: newColor)
        }
    }

    private func updateStrokeEndIfNeeded(at index: Int, updatedSection: ClockSectionViewModel) {
        let displayedStrokeEnd = ClockSectionAnimatedLayer.strokeEnd(for: viewModel)
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
        return CACurrentMediaTime() + Double(index) * 0.5 / CGFloat(size)
    }

    // Static methods
    private static func strokeEnd(for section: ClockSectionViewModel) -> CGFloat {
        section.length
    }

    private static func color(for section: ClockSectionViewModel) -> UIColor {
        section.length == 0 ?
            UIHelper.clockSectionBackground :
            UIHelper.brand
    }
}
