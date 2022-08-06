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

    private var viewRoot = UIView(al: true)
    private var backgroundContainer = UIView(al: true)
    private var sectionsContainer = UIView(al: true)
    private var sectionsAmount: Int = 0
    private var sectionLayersInstalled = false

    private var labelDay: UILabel = DayOfTheWeekCell.makeLabel()
    private var labelAmount: UILabel = DayOfTheWeekCell.makeLabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewsHierarchy()
        configureViews()
        viewRoot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePress)))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureViews() {
        backgroundContainer.backgroundColor = UIHelper.background
        backgroundContainer.layer.cornerRadius = UIHelper.spacing / 1.5

        sectionsContainer.transform = CGAffineTransform(scaleX: 1, y: -1)
        sectionsContainer.clipsToBounds = true
    }

    private func configureViewsHierarchy() {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.spacing = UIHelper.spacing / 2
        stack.distribution = .fill

        stack.addArrangedSubview(labelAmount)
        stack.addArrangedSubview(sectionsContainer)
        stack.addArrangedSubview(labelDay)

        backgroundContainer.addSubview(stack)
        viewRoot.addSubview(backgroundContainer)
        contentView.addAndConstrain(viewRoot)

        labelAmount.setContentHuggingPriority(UILayoutPriority(250), for: .vertical)
        labelDay.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        sectionsContainer.setContentHuggingPriority(UILayoutPriority(249), for: .vertical)
        sectionsContainer.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        NSLayoutConstraint.activate([
            backgroundContainer.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: UIHelper.spacing / 2),
            backgroundContainer.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -UIHelper.spacing / 2),
            backgroundContainer.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            backgroundContainer.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor, constant: -UIHelper.spacing),

            stack.widthAnchor.constraint(equalTo: backgroundContainer.widthAnchor, constant: -UIHelper.spacing),
            stack.heightAnchor.constraint(equalTo: backgroundContainer.heightAnchor, constant: -UIHelper.spacing),
            stack.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: backgroundContainer.centerYAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        sectionsAmount = 0
        delegate = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        installSectionsLayersIfNeeded()
        configureSectionsVisibility()
    }

    private func installSectionsLayersIfNeeded() {
        guard !sectionLayersInstalled else { return }

        for i in 0 ... 20 {
            let layer = CAShapeLayer()
            let offset = Double(i) * (Self.sectionsHeight + Self.sectionsSpacing)
            let rect = CGRect(x: 0, y: offset, width: bounds.width - 2 * UIHelper.spacing, height: Self.sectionsHeight)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: Self.sectionsHeight / 2)
            layer.path = path.cgPath
            layer.fillColor = UIHelper.brandDimmed.cgColor
            sectionsContainer.layer.addSublayer(layer)
        }

        sectionLayersInstalled = true
    }
}

// MARK: - Public
extension DayOfTheWeekCell {
    func configure(day: String, isToday: Bool = false) {
        labelDay.text = day
        labelDay.textColor = isToday ? UIHelper.brand : UIHelper.itemFont
    }

    func configure(amount: Int?) {
        if amount == nil || amount == 0 {
            labelAmount.text = " "
            sectionsAmount = 0
        } else {
            labelAmount.text = "\(amount!)"
            sectionsAmount = amount!
        }
    }
}

// MARK: - Private
extension DayOfTheWeekCell {
    private func configureSectionsVisibility() {
        hideAllSections()
        enableSections()
    }

    private func hideAllSections() {
        guard let sublayers = sectionsContainer.layer.sublayers else { return }
        for sublayer in sublayers { sublayer.opacity = 0.0 }
    }

    private func enableSections() {
        guard let sublayers = sectionsContainer.layer.sublayers else { return }

        for (index, sublayer) in sublayers.enumerated() {
            if index < sectionsAmount { sublayer.opacity = 1.0 }
        }
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
