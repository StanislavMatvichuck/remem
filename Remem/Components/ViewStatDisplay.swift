//
//  StatDisplay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 18.02.2022.
//

import UIKit

class ViewStatDisplay: UIView {
    // MARK: - Init
    init(value: NSNumber, description: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = .delta1

        let labelAmount = UILabel(al: true)
        labelAmount.text = formatter.string(from: value)
        labelAmount.numberOfLines = 1
        labelAmount.font = .systemFont(ofSize: .font2)
        labelAmount.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let labelDescription = UILabel(al: true)
        labelDescription.text = description
        labelDescription.font = .systemFont(ofSize: .font1)
        labelDescription.numberOfLines = 0
        labelDescription.setContentHuggingPriority(.defaultLow, for: .vertical)

        let flexibleSpace = UIView(al: true)

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.spacing = .delta1

        stack.addArrangedSubview(labelAmount)
        stack.addArrangedSubview(labelDescription)
        stack.addArrangedSubview(flexibleSpace)
        stack.setCustomSpacing(0, after: labelDescription)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .delta1),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.delta1),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.delta1),
            widthAnchor.constraint(equalToConstant: (.wScreen - 3 * .delta1) / 2),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
