//
//  ViewMainRow.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class ViewMainRow: UITableViewCell {
    //

    // MARK: - Static properties

    //

    static let reuseIdentifier = "ViewMainRow"

    //

    // MARK: - Public properties

    //

    //

    // MARK: - Private properties

    //

    private let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1

        return label
    }()

    //

    // MARK: - Initialization

    //

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .orange

        contentView.addSubview(nameLabel)
        contentView.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .hButton),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.hButton),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .md),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.md),

            valueLabel.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.hButton),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Behaviour

    //

    func update(name: String) {
        nameLabel.text = name
    }

    func update(value: Int) {
        valueLabel.text = "\(value)"
    }
}
