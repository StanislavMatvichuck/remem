//
//  StatDisplay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 18.02.2022.
//

import UIKit

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
    init(value: Float, description: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        let viewStatContainer = UIView(frame: .zero)
        viewStatContainer.translatesAutoresizingMaskIntoConstraints = false
        viewStatContainer.backgroundColor = .secondarySystemBackground
        viewStatContainer.layer.cornerRadius = 10

        let labelAmount = UILabel(frame: .zero)

        labelAmount.translatesAutoresizingMaskIntoConstraints = false
        labelAmount.text = formatter.string(from: NSNumber(value: value))
        labelAmount.numberOfLines = 1
        labelAmount.font = UIFont.systemFont(ofSize: 32)
        labelAmount.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let labelDescription = UILabel(frame: .zero)

        labelDescription.translatesAutoresizingMaskIntoConstraints = false
        labelDescription.text = description
        labelDescription.font = .systemFont(ofSize: 16)
        labelDescription.numberOfLines = 2
        labelDescription.setContentHuggingPriority(.defaultLow, for: .vertical)

        viewStatContainer.addSubview(labelAmount)
        viewStatContainer.addSubview(labelDescription)
        addAndConstrain(viewStatContainer, constant: 10)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: .wScreen / 2),

            labelAmount.leadingAnchor.constraint(equalTo: viewStatContainer.leadingAnchor, constant: 10),
            labelAmount.trailingAnchor.constraint(equalTo: viewStatContainer.trailingAnchor, constant: -10),
            labelDescription.leadingAnchor.constraint(equalTo: viewStatContainer.leadingAnchor, constant: 10),
            labelDescription.trailingAnchor.constraint(equalTo: viewStatContainer.trailingAnchor, constant: -10),

            labelAmount.topAnchor.constraint(equalTo: viewStatContainer.topAnchor, constant: 10),
            labelAmount.bottomAnchor.constraint(equalTo: labelDescription.topAnchor),
            labelDescription.bottomAnchor.constraint(equalTo: viewStatContainer.bottomAnchor, constant: -10),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
