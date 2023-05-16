//
//  InputView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 16.05.2023.
//

import UIKit

final class InputView: UIView {
    let textField: UITextField = {
        let input = UITextField(al: true)
        input.font = .font
        input.textAlignment = .center
        input.backgroundColor = .clear
        input.adjustsFontSizeToFitWidth = true
        input.minimumFontSize = UIFont.fontSmall.pointSize
        input.returnKeyType = .done
        return input
    }()

    let viewInput: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = .bg_item
        view.layer.cornerRadius = .buttonRadius
        view.layer.borderColor = UIColor.border.cgColor
        view.layer.borderWidth = .border
        view.isOpaque = true
        view.layer.shadowRadius = 30
        view.layer.shadowColor = UIColor.secondarySystemBackground.cgColor
        view.layer.shadowOpacity = 1
        return view
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        viewInput.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: viewInput.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: viewInput.centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: .buttonHeight),
            textField.widthAnchor.constraint(equalTo: viewInput.widthAnchor, constant: -2 * .buttonHeight),
        ])

        addSubview(viewInput)
        NSLayoutConstraint.activate([
            viewInput.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * .buttonMargin),
            viewInput.heightAnchor.constraint(equalToConstant: .buttonHeight),
            viewInput.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    private func configureAppearance() {}
}
