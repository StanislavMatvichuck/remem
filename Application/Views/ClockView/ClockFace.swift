//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

final class ClockFace: UIView {
    var viewModel: ClockViewModel {
        didSet {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)

            for oldItem in oldValue.items {
                let index = oldItem.index
                let newItem = viewModel.items[index]

                if newItem != oldItem {
                    guard let layer = layer.sublayers?[index] as? CAShapeLayer else { continue }
                    layer.strokeEnd = strokeEnd(for: newItem)
                    layer.strokeColor = color(for: newItem)
                }
            }

            CATransaction.commit()
        }
    }

    init(viewModel: ClockViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()

        if layer.sublayers == nil {
            installAnimatedSublayers()
        }
    }

    /// Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        for item in viewModel.items {
            if let shape = layer.sublayers?[item.index] as? CAShapeLayer {
                shape.strokeColor = color(for: item)
            }
        }
    }

    private func installAnimatedSublayers() {
        viewModel.items.forEach {
            layer.addSublayer(makeSublayer(for: $0))
        }
    }

    private func makeSublayer(for item: ClockCellViewModel) -> CALayer {
        let layer = CAShapeLayer()
        layer.strokeColor = color(for: item)
        layer.path = makePath(for: item)
        layer.strokeEnd = strokeEnd(for: item)
        layer.lineCap = .round
        layer.lineWidth = 3.0
        return layer
    }

    private func makePath(for item: ClockCellViewModel) -> CGPath {
        let radius = bounds.width / 2
        let sectionMaximumLength = bounds.width * ClockSectionMultiplier
        let path = UIBezierPath()
        path.move(to: .zero)
        path.move(to: CGPoint(x: 0, y: radius - sectionMaximumLength))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.move(to: CGPoint(x: 0, y: radius))
        path.move(to: CGPoint(x: 0, y: -radius))
        path.rotate(degree: angle(for: item))
        path.apply(CGAffineTransform(
            translationX: radius,
            y: radius
        ))

        return path.cgPath
    }

    private func angle(for item: ClockCellViewModel) -> CGFloat {
        (360.0 / CGFloat(item.clockSize)) * CGFloat(item.index)
    }

    private func strokeEnd(for item: ClockCellViewModel) -> CGFloat {
        0.01 + 0.95 * item.length
    }

    private func color(for item: ClockCellViewModel) -> CGColor {
        item.isEmpty ? UIColor.secondary.withAlphaComponent(0.5).cgColor : UIColor.text.cgColor
    }
}

extension UIBezierPath {
    func rotate(degree: CGFloat) {
        let bounds: CGRect = cgPath.boundingBox
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        let radians = degree / 180.0 * .pi
        var transform: CGAffineTransform = .identity
        transform = transform.translatedBy(x: center.x, y: center.y)
        transform = transform.rotated(by: radians)
        transform = transform.translatedBy(x: -center.x, y: -center.y)
        apply(transform)
    }
}
