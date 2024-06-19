//
//  CircularGraphView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.06.2024.
//

import UIKit

struct CircularVertex {
    let text: String
    var value: CGFloat
}

protocol CircularViewModeling {
    var vertices: [CircularVertex] { get }
    var rotationAngle: CGFloat { get }
}

class CircularGraphView: UIView {
    var viewModel: CircularViewModeling { didSet {
        dataShapeLayer?.path = makeDataPath()
    } }

    private let fullCircleAngle = 2 * CGFloat.pi
    private var verticesCount: Int { viewModel.vertices.count }
    private var anglePartitioner: CGFloat { CGFloat(verticesCount) }
    private var anglePart: CGFloat { fullCircleAngle / anglePartitioner }
    private var angleCompensation: CGFloat { viewModel.rotationAngle }
    private let labelDistanceCompensation = 16.0
    private var fullRadius: CGFloat { bounds.midX * 0.8 }
    private let minimalRadius = 0.2

    private let strokeWidth = CGFloat.border
    private let strokeColor = UIColor.remem_secondary.withAlphaComponent(0.25).cgColor
    private let fillColor = UIColor.remem_secondary
    private let fillColorOpacity: CGFloat = 0.1

    private var firstBackgroundShapeLayer: CAShapeLayer?
    private var secondBackgroundShapeLayer: CAShapeLayer?
    private var thirdBackgroundShapeLayer: CAShapeLayer?
    private var fourthBackgroundShapeLayer: CAShapeLayer?
    private var starShapeLayer: CAShapeLayer?
    private var dataShapeLayer: CAShapeLayer?

    private var labelsConstraints = [(x: NSLayoutConstraint, y: NSLayoutConstraint)]()

    init(viewModel: CircularViewModeling) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - View lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        installBackgroundLayers()
        installStarShapeLayerIfNeeded()
        installDataShapeLayerIfNeeded()
        configureLabelsPositions()
    }

    // MARK: - Private
    private func configureLayout() {
        widthAnchor.constraint(equalTo: heightAnchor).isActive = true

        for index in 0 ..< viewModel.vertices.count {
            let label = UILabel(al: true)
            label.text = viewModel.vertices[index].text
            label.font = .fontExtraSmall
            label.textColor = UIColor.remem_secondary
            addSubview(label)

            let xConstraint = label.centerXAnchor.constraint(equalTo: centerXAnchor)
            xConstraint.isActive = true

            let yConstraint = label.centerYAnchor.constraint(equalTo: centerYAnchor)
            yConstraint.isActive = true

            labelsConstraints.append((x: xConstraint, y: yConstraint))
        }
    }

    private func configureAppearance() { backgroundColor = .remem_bg }

    private func configureLabelsPositions() {
        for (index, constraintPair) in labelsConstraints.enumerated() {
            constraintPair.x.constant = x(for: index, offset: labelDistanceCompensation)
            constraintPair.y.constant = y(for: index, offset: labelDistanceCompensation)
        }
    }

    // MARK: - Layers

    private func installBackgroundLayers() {
        installIfNeeded(backgroundLayer: &firstBackgroundShapeLayer, scale: length(for: 1.0))
        firstBackgroundShapeLayer?.strokeColor = strokeColor
        firstBackgroundShapeLayer?.lineWidth = strokeWidth
        installIfNeeded(backgroundLayer: &secondBackgroundShapeLayer, scale: length(for: 0.66))
        installIfNeeded(backgroundLayer: &thirdBackgroundShapeLayer, scale: length(for: 0.33))
        installIfNeeded(backgroundLayer: &fourthBackgroundShapeLayer, scale: length(for: 0))
        fourthBackgroundShapeLayer?.fillColor = UIColor.remem_secondary.cgColor
    }

    private func installIfNeeded(backgroundLayer: inout CAShapeLayer?, scale: CGFloat) {
        guard backgroundLayer == nil else { return }
        let shapeLayer = makeBackgroundShapeLayer(scale: scale)
        layer.addSublayer(shapeLayer)
        backgroundLayer = shapeLayer
    }

    private func installStarShapeLayerIfNeeded() {
        guard starShapeLayer == nil else { return }
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = makeStarPath()
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = strokeWidth
        layer.addSublayer(shapeLayer)
        starShapeLayer = shapeLayer
    }

    private func installDataShapeLayerIfNeeded() {
        guard dataShapeLayer == nil else { return }
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = bounds
        shapeLayer.path = makeDataPath()
        shapeLayer.strokeColor = UIColor.remem_primary.cgColor
        shapeLayer.lineWidth = strokeWidth * 3
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = UIColor.remem_primary.withAlphaComponent(fillColorOpacity).cgColor
        layer.addSublayer(shapeLayer)
        dataShapeLayer = shapeLayer
    }

    // MARK: - Drawing

    private func makeBackgroundShapeLayer(scale: CGFloat) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = bounds
        layer.path = makeBackgroundPath()
        layer.fillColor = fillColor.withAlphaComponent(fillColorOpacity).cgColor
        layer.transform = CATransform3DMakeScale(scale, scale, 1)
        return layer
    }

    private func makeBackgroundPath() -> CGPath {
        let path = UIBezierPath()

        for index in 0 ..< verticesCount {
            let x = bounds.midX + x(for: index)
            let y = bounds.midY + y(for: index)
            let point = CGPoint(x: x, y: y)

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.close()
        return path.cgPath
    }

    private func makeStarPath() -> CGPath {
        let path = UIBezierPath()

        for index in 0 ..< verticesCount {
            let x = bounds.midX + x(for: index)
            let y = bounds.midY + y(for: index)
            let point = CGPoint(x: x, y: y)

            path.move(to: CGPoint(x: bounds.midX, y: bounds.midY))
            path.addLine(to: point)
        }

        return path.cgPath
    }

    private func makeDataPath() -> CGPath {
        let path = UIBezierPath()

        for index in 0 ..< verticesCount {
            let value = viewModel.vertices[index].value
            let x = bounds.midX + x(for: index) * length(for: value)
            let y = bounds.midY + y(for: index) * length(for: value)
            let point = CGPoint(x: x, y: y)

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        path.close()
        return path.cgPath
    }

    private func x(for index: Int, offset: CGFloat = 0) -> CGFloat { (fullRadius + offset) * cos(angle(for: index)) }
    private func y(for index: Int, offset: CGFloat = 0) -> CGFloat { (fullRadius + offset) * sin(angle(for: index)) }
    private func angle(for index: Int) -> CGFloat { CGFloat(index) * anglePart - angleCompensation }
    private func length(for value: CGFloat) -> CGFloat { (minimalRadius + (1 - minimalRadius) * value) }
}
