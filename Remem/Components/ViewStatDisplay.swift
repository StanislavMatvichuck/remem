//
//  StatDisplay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 18.02.2022.
//

import UIKit

class ViewStatDisplay: UIView {
    //

    // MARK: - Public properties

    //
    //

    // MARK: - Private properties

    //

    //

    // MARK: - Initialization

    //
    init(value: NSNumber, description: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = .delta1

        let labelAmount = UILabel(frame: .zero)
        labelAmount.translatesAutoresizingMaskIntoConstraints = false
        labelAmount.text = formatter.string(from: value)
        labelAmount.numberOfLines = 1
        labelAmount.font = .systemFont(ofSize: .font2)
        labelAmount.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let labelDescription = UILabel(frame: .zero)
        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.text = description
        labelDescription.font = .systemFont(ofSize: .font1)
        labelDescription.numberOfLines = 2
        labelDescription.setContentHuggingPriority(.defaultLow, for: .vertical)

        addSubview(labelAmount)
        addSubview(labelDescription)

        NSLayoutConstraint.activate([
            labelAmount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .delta1),
            labelAmount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.delta1),
            labelDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .delta1),
            labelDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.delta1),

            labelAmount.topAnchor.constraint(equalTo: topAnchor),
            labelAmount.bottomAnchor.constraint(equalTo: labelDescription.topAnchor),
            labelDescription.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.delta1),

            widthAnchor.constraint(equalToConstant: (.wScreen - 3 * .delta1) / 2),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
