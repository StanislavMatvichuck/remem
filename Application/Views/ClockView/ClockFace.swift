//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

final class ClockFace: UIView {
    static let sectionMaximumLength = CGFloat.layoutSquare * 1.5
    static let lineWidth: CGFloat = 7
    static var lineCapRadius: CGFloat { lineWidth / 2 }

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
        layer.lineWidth = Self.lineWidth
        return layer
    }

    private func makePath(for item: ClockCellViewModel) -> CGPath {
        let radius = bounds.width / 2

        let lineStart = CGPoint(x: 0, y: radius - Self.sectionMaximumLength)
        let lineEnd = CGPoint(x: 0, y: radius - Self.lineCapRadius)

        let path = UIBezierPath()
        path.move(to: lineStart)
        path.addLine(to: lineEnd)

        path.apply(.identity.rotated(by: angle(for: item)))
        path.apply(CGAffineTransform(translationX: radius, y: radius))

        return path.cgPath
    }

    private func angle(for item: ClockCellViewModel) -> CGFloat {
        2 * .pi / CGFloat(item.clockSize) * CGFloat(item.index)
    }

    private func strokeEnd(for item: ClockCellViewModel) -> CGFloat {
        0.001 + 0.95 * item.length
    }

    private func color(for item: ClockCellViewModel) -> CGColor {
        item.isEmpty ? UIColor.secondary.withAlphaComponent(0.5).cgColor : UIColor.text.cgColor
    }
}
