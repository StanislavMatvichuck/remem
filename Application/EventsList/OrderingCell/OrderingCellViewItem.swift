//
//  OrderingItemViewItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.04.2023.
//

import UIKit

final class OrderingCellViewItem: UIStackView {
    static let height = CGFloat.layoutSquare * 0.8
    static let width = CGFloat.layoutSquare * 4
    static let accessoryWidth = width / 3.5
    static let accessoryPointWidth = CGFloat.layoutSquare / 10

    let title: UILabel = {
        let title = UILabel(al: true)
        title.font = .font
        title.textColor = .primary
        title.textAlignment = .center
        title.text = "Аlphabetically"
        return title
    }()

    let accessoryTopLabel: UILabel = {
        let accessoryTopLabel = UILabel(al: true)
        accessoryTopLabel.font = .fontExtraSmall
        accessoryTopLabel.textColor = .bg_secondary
        accessoryTopLabel.text = "start"
        return accessoryTopLabel
    }()

    let accessoryBottomLabel: UILabel = {
        let accessoryBottomLabel = UILabel(al: true)
        accessoryBottomLabel.font = .fontExtraSmall
        accessoryBottomLabel.textColor = .bg_secondary
        accessoryBottomLabel.text = "end"
        return accessoryBottomLabel
    }()

    let image: UIImageView = {
        let symbol = UIImage(systemName: "triangle.fill")?
            .withTintColor(.bg_secondary)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 18)))

        let image = UIImageView(al: true)
        image.image = symbol

        return image
    }()

    init(_ vm: OrderingCellItemViewModel) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureContent(vm)
        configureAppearance()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureContent(_ vm: OrderingCellItemViewModel) {
        title.text = vm.title
    }

    // MARK: - Private
    private func configureLayout() {
        axis = .horizontal

        let accessoryPoint = UIView(al: true)
        accessoryPoint.backgroundColor = .bg_secondary
        accessoryPoint.layer.cornerRadius = Self.accessoryPointWidth / 2

        let accessory = UIView(al: true)
        accessory.backgroundColor = .secondary
        accessory.layer.cornerRadius = Self.height / 2
        accessory.addSubview(image)
        accessory.addSubview(accessoryPoint)
        accessory.addSubview(accessoryTopLabel)
        accessory.addSubview(accessoryBottomLabel)

        // TODO: finish sorting variants to be reversible
//        addArrangedSubview(accessory)
        addArrangedSubview(title)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Self.width),
            heightAnchor.constraint(equalToConstant: Self.height),

            accessory.widthAnchor.constraint(equalToConstant: Self.accessoryWidth),
            accessoryPoint.widthAnchor.constraint(equalToConstant: Self.accessoryPointWidth),
            accessoryPoint.heightAnchor.constraint(equalToConstant: Self.accessoryPointWidth),
            accessoryPoint.centerXAnchor.constraint(equalTo: accessory.centerXAnchor),
            accessoryPoint.centerYAnchor.constraint(equalTo: accessory.centerYAnchor),

            image.centerXAnchor.constraint(equalTo: accessory.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: accessory.centerYAnchor),

            accessoryTopLabel.centerXAnchor.constraint(equalTo: accessory.centerXAnchor),
            accessoryTopLabel.topAnchor.constraint(equalTo: accessory.topAnchor),

            accessoryBottomLabel.centerXAnchor.constraint(equalTo: accessory.centerXAnchor),
            accessoryBottomLabel.bottomAnchor.constraint(equalTo: accessory.bottomAnchor),
        ])
    }

    private func configureAppearance() {
        backgroundColor = .bg_item
        layer.cornerRadius = Self.height / 2
        layer.borderColor = UIColor.border.cgColor
        layer.borderWidth = .border
    }
    
    // MARK: - Dark mode
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureAppearance()
    }
}
