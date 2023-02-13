//
//  UIHelper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.06.2022.
//

import UIKit

struct UIHelper {
    // colors
    static let background = UIColor.secondarySystemBackground
    static let itemBackground = UIColor.systemBackground
    static let clockSectionBackground = UIColor.systemGray4
    static let goalReachedBackground = UIColor(named: "goalReachedBackground")!
    static let goalNotReachedBackground = UIColor(named: "goalNotReachedBackground")!
    static let brand = UIColor.systemBlue
    static let brandDimmed = UIColor(named: "brandDimmed")!
    static let secondary = UIColor.systemOrange
    static let itemFont = UIColor.gray
    static let hint = UIColor.systemGray3
    static let pinColor = Self.brandDimmed
    static let colorButtonText = brand
    static let colorButtonTextHighLighted = itemBackground
    // metrics
    static let spacing = 8.0
    static let spacingListHorizontal = 12.0
    static let radius = 4.0
    static var r1: CGFloat { 32.0 }
    static var r2: CGFloat { r1 + delta1 }
    static var r0: CGFloat { r1 - delta1 }
    static var delta1: CGFloat { 8 }
    static var d1: CGFloat { 2 * r1 }
    static var d2: CGFloat { 2 * r2 }
    static var height: CGFloat { Self.d2 + Self.spacing }

    // fonts
    static let font: UIFont = makeFont()
    static let fontBold: UIFont = makeFont(size: 32.0, weight: .bold)
    static let fontBoldBig: UIFont = makeFont(size: 48.0, weight: .bold)
    static let fontSmallBold: UIFont = makeFont(size: 17.0, weight: .bold)
    static let fontSmall: UIFont = makeFont(size: 12.0, weight: .regular)

    private static func makeFont(
        size: CGFloat = 17.0,
        weight: UIFont.Weight = .regular) -> UIFont
    {
        let font = UIFont.systemFont(ofSize: size, weight: weight)
        if let descriptor = font.fontDescriptor.withDesign(.rounded) {
            return UIFont(descriptor: descriptor, size: size)
        }
        return font
    }
}
