//
//  UIHelper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.06.2022.
//

import UIKit

struct UIHelper {
    static let background = UIColor.systemBackground
    static let itemBackground = UIColor.secondarySystemBackground
    static let brand = UIColor.systemBlue
    static let brandDimmed = brand.withAlphaComponent(0.3)
    static let secondary = UIColor.systemOrange
    static let itemFont = UIColor.gray

    static let font: UIFont = {
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)

        if let descriptor = font.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: 17)
        }

        return font
    }()

    static let fontBold: UIFont = {
        let size = 32.0
        let font = UIFont.systemFont(ofSize: size, weight: .bold)

        if let descriptor = font.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: size)
        }

        return font
    }()

    static let spacing = 16.0
    static let spacingListHorizontal = 32.0
}
