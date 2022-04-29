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
        layer.cornerRadius = .sm

        let labelAmount = UILabel(al: true)
        labelAmount.text = formatter.string(from: value)
        labelAmount.numberOfLines = 1
        labelAmount.font = .systemFont(ofSize: .font2, weight: .bold)
        labelAmount.textColor = UIColor.label
        labelAmount.setContentHuggingPriority(.defaultHigh, for: .vertical)

        let labelDescription = UILabel(al: true)
        labelDescription.text = description
        labelDescription.font = .systemFont(ofSize: .font1)
        labelDescription.numberOfLines = 0
        labelDescription.setContentHuggingPriority(.defaultLow, for: .vertical)

        let flexibleSpace = UIView(al: true)

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.spacing = .xs

        stack.addArrangedSubview(labelAmount)
        stack.addArrangedSubview(labelDescription)
        stack.addArrangedSubview(flexibleSpace)
        stack.setCustomSpacing(0, after: labelDescription)

        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .xs),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.xs),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.xs),
            widthAnchor.constraint(equalToConstant: .wScreen / 2.5),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
