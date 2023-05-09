//
//  UIHelper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.06.2022.
//

import UIKit

extension UIColor {
    static let background = UIColor(named: "background")!
    static let background_secondary = UIColor(named: "background_secondary")!
    static let primary = UIColor(named: "primary")!
    static let primary_dimmed = UIColor(named: "primary_dimmed")!
    static let secondary = UIColor(named: "secondary")!
    static let secondary_dimmed = UIColor(named: "secondary_dimmed")!
    static let text_primary = UIColor(named: "text_primary")!
    static let text_secondary = UIColor(named: "text_secondary")!
    static let goal_achieved = UIColor(named: "goal_achieved")!
}

extension CGFloat {
    static let screenW: CGFloat = UIScreen.main.bounds.width
    static let layoutSquare: CGFloat = screenW / 7
    static let buttonHeight: CGFloat = 2 * layoutSquare * 0.8
    static let buttonRadius: CGFloat = buttonHeight / 2
    static let buttonMargin: CGFloat = layoutSquare - buttonRadius
    static let swiperRadius: CGFloat = buttonRadius - buttonMargin
}

extension UIFont {
    static let font: UIFont = makeFont()
    static let fontBold: UIFont = makeFont(size: 32.0, weight: .bold)
    static let fontBoldBig: UIFont = makeFont(size: 48.0, weight: .bold)
    static let fontSmallBold: UIFont = makeFont(size: 17.0, weight: .bold)
    static let fontSmall: UIFont = makeFont(size: 12.0, weight: .regular)
    static let fontExtraSmall: UIFont = makeFont(size: 10.0, weight: .semibold)

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
