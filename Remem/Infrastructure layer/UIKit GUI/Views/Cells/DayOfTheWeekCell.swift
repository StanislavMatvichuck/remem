//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

protocol DayOfTheWeekCellDelegate: AnyObject {
    func didPress(cell: DayOfTheWeekCell)
}

class DayOfTheWeekCell: UICollectionViewCell {
    static let reuseIdentifier = "CellDay"

    static let sectionsSpacing = 2.0
    static let sectionsHeight = 12.0
    static let sectionsAmount = 20

    enum Kind {
        case past
        case created
        case data
        case today
        case future
    }

    // MARK: - Properties
    weak var delegate: DayOfTheWeekCellDelegate?

    var viewRoot = UIView(al: true)
    var backgroundContainer = UIView(al: true)
    var sectionsContainer = UIView(al: true)

    var labelDay: UILabel = DayOfTheWeekCell.makeLabel()
    var labelAmount: UILabel = DayOfTheWeekCell.makeLabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewsHierarchy()
        configureViews()
        viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePress)))
        configureSectionsLayers()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureViews() {
        backgroundContainer.backgroundColor = UIHelper.background
        backgroundContainer.layer.cornerRadius = UIHelper.radius

        sectionsContainer.transform = CGAffineTransform(scaleX: 1, y: -1)
        sectionsContainer.clipsToBounds = true
    }

    private func configureViewsHierarchy() {
        let spacing = UIHelper.spacing / 8

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.spacing = spacing
        stack.distribution = .fill
        stack.addArrangedSubview(sectionsContainer)
        stack.addArrangedSubview(labelDay)

        backgroundContainer.addSubview(stack)
        viewRoot.addSubview(labelAmount)
        viewRoot.addSubview(backgroundContainer)
        contentView.addAndConstrain(viewRoot)

        labelDay.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        sectionsContainer.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        sectionsContainer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate([
            backgroundContainer.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: spacing),
            backgroundContainer.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -spacing),

            labelAmount.topAnchor.constraint(equalTo: viewRoot.topAnchor, constant: spacing),
            labelAmount.widthAnchor.constraint(equalTo: viewRoot.widthAnchor),

            backgroundContainer.topAnchor.constraint(equalTo: labelAmount.bottomAnchor, constant: spacing),
            backgroundContainer.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor, constant: -UIHelper.spacing / 2),

            stack.widthAnchor.constraint(equalTo: backgroundContainer.widthAnchor, constant: -spacing),
            stack.heightAnchor.constraint(equalTo: backgroundContainer.heightAnchor, constant: -spacing),
            stack.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor),
        ])
    }

    override func prepareForReuse() {
        hideAllSections()
        delegate = nil
        super.prepareForReuse()
    }

    private func configureSectionsLayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        for i in 0 ... 19 {
            let layer = makeSectionLayer(for: i)
            sectionsContainer.layer.addSublayer(layer)
        }

        CATransaction.commit()
    }

    private func makeSectionLayer(for index: Int) -> CALayer {
        let offset = Double(index) * (Self.sectionsHeight + Self.sectionsSpacing)
        let rect = CGRect(x: 0, y: offset, width: bounds.width - 2 * UIHelper.spacing, height: Self.sectionsHeight)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: Self.sectionsHeight / 2)

        let layer = CAShapeLayer()
        layer.fillColor = UIHelper.brandDimmed.cgColor
        layer.path = path.cgPath
        layer.opacity = 0.0

        return layer
    }
}

// MARK: - Public
extension DayOfTheWeekCell {
    func showSections(amount: Int) {
        guard let sublayers = sectionsContainer.layer.sublayers else { return }

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        for (index, sublayer) in sublayers.enumerated() {
            if index < amount { sublayer.opacity = 1.0 }
        }

        CATransaction.commit()
    }
}

// MARK: - Private
extension DayOfTheWeekCell {
    private func hideAllSections() {
        guard let sublayers = sectionsContainer.layer.sublayers else { return }

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        for sublayer in sublayers { sublayer.opacity = 0.0 }

        CATransaction.commit()
    }

    private static func makeLabel() -> UILabel {
        let label = UILabel(al: true)

        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIHelper.fontSmallBold
        label.textColor = UIHelper.itemFont
        label.text = " "

        return label
    }

    @objc private func handlePress() {
        delegate?.didPress(cell: self)
    }
}
