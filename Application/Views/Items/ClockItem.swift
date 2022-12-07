//
//  ClockSectionAnimatedLayer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 04.06.2022.
//

import UIKit

class ClockItem: CAShapeLayer {
    static let length = 48.0
    static let width = 3.0

    // MARK: - Properties
    var viewModel: ClockItemViewModel! {
        didSet {
            if let oldValue, let viewModel {
                if ClockItem.color(for: oldValue) !=
                    ClockItem.color(for: viewModel)
                {
                    addColorAnimation(
                        from: ClockItem.color(for: oldValue),
                        to: ClockItem.color(for: viewModel)
                    )
                }

                if ClockItem.strokeEnd(for: oldValue) !=
                    ClockItem.strokeEnd(for: viewModel)
                {
                    addStrokeEndAnimation(
                        from: ClockItem.strokeEnd(for: oldValue),
                        to: ClockItem.strokeEnd(for: viewModel)
                    )
                }
            }
        }
    }

    private var beginTimeOffset: CFTimeInterval {
        CACurrentMediaTime() + Double(viewModel.index) * 0.5 / CGFloat(size)
    }

    var center: CGPoint { CGPoint(x: bounds.midX, y: bounds.midY) }
    var size: Int!

    // MARK: - Init
    init(section: ClockItemViewModel, frame: CGRect, size: Int) {
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
        rotate()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension ClockItem {
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

    private func rotate() {
        let angleDegrees = 360.0 / CGFloat(size) * CGFloat(viewModel.index)
        let angleRad = ((angleDegrees + 180.0) * CGFloat.pi) / 180.0
        transform = CATransform3DMakeRotation(angleRad, 0, 0, 1)
    }

    private func addColorAnimation(from: UIColor, to: UIColor) {
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.duration = 0.1
        animation.fromValue = from.cgColor
        animation.toValue = to.cgColor
        animation.fillMode = .backwards
        animation.beginTime = beginTime

        strokeColor = to.cgColor
        add(animation, forKey: nil)
    }

    private func addStrokeEndAnimation(from: CGFloat, to: CGFloat) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        animation.fromValue = from
        animation.toValue = to
        animation.fillMode = .backwards

        animation.beginTime = beginTimeOffset

        strokeEnd = to
        add(animation, forKey: nil)
    }

    // Static methods
    private static func strokeEnd(for section: ClockItemViewModel) -> CGFloat {
        0.2 + 0.8 * section.length
    }

    private static func color(for section: ClockItemViewModel) -> UIColor {
        section.length == 0 ?
            UIHelper.clockSectionBackground :
            UIHelper.brand
    }
}
