//
//  UITextFieldWithPadding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.04.2022.
//

import Foundation
import UIKit

class UITextFieldWithPadding: UITextField {
    let textPadding: UIEdgeInsets

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    init(_ padding: UIEdgeInsets =
        UIEdgeInsets(
            top: SettingsView.margin,
            left: SettingsView.margin,
            bottom: SettingsView.margin,
            right: SettingsView.margin
        ))
    {
        textPadding = padding
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
