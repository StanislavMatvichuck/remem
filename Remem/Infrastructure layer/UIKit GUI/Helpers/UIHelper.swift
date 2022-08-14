//
//  UIHelper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.06.2022.
//

import UIKit

struct UIHelper {
    // colors
    static let background = UIColor.systemBackground
    static let itemBackground = UIColor.secondarySystemBackground
    static let clockSectionBackground = UIColor.systemGray4
    static let brand = UIColor.systemBlue
    static let brandDimmed = brand.withAlphaComponent(0.3)
    static let secondary = UIColor.systemOrange
    static let itemFont = UIColor.gray
    // metrics
    static let spacing = 16.0
    static let spacingListHorizontal = 32.0
    static let radius = 8.0
    // fonts
    static let font: UIFont = makeFont()
    static let fontBold: UIFont = makeFont(size: 32.0, weight: .bold)
    static let fontSmallBold: UIFont = makeFont(size: 17.0, weight: .bold)
}

// MARK: - Private
extension UIHelper {
    private static
    func makeFont(size: CGFloat = 17.0,
                  weight: UIFont.Weight = .regular)
        -> UIFont
    {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        if let descriptor = font.fontDescriptor.withDesign(.rounded) { return UIFont(descriptor: descriptor, size: size) }
        return font
    }
}
