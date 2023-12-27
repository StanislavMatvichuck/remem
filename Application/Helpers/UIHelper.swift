//
//  UIHelper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.06.2022.
//

import UIKit

extension UIColor {
    static let primary = UIColor(named: "primary")!
    static let secondary = UIColor(named: "secondary")!

    static let bg = UIColor(named: "bg")!
    static let bg_item = UIColor(named: "bg_item")!
    static let bg_primary = UIColor(named: "bg_primary")!
    static let bg_secondary = UIColor(named: "bg_secondary")!
    static let bg_goal = UIColor(named: "bg_goal")!
    static let bg_goal_achieved = UIColor(named: "bg_goal_achieved")!

    static let text = UIColor(named: "text")!
    static let text_goalAchieved = UIColor(named: "text_goalAchieved")!
    static let border = UIColor(named: "border")!
    static let border_primary = UIColor(named: "border_primary")!
}

extension CGFloat {
    static let screenW: CGFloat = UIScreen.main.bounds.width
    static let layoutSquare: CGFloat = screenW / 7
    static let buttonHeight: CGFloat = 2 * layoutSquare * 0.8
    static let buttonRadius: CGFloat = buttonHeight / 2
    static let buttonMargin: CGFloat = layoutSquare - buttonRadius
    static let swiperRadius: CGFloat = buttonRadius - buttonMargin
    static let border: CGFloat = 0.5
}

extension CGRect {
    static let screenSquare = CGRect(x: 0, y: 0, width: .screenW, height: .screenW)
}

extension UIFont {
    static let font: UIFont = makeFont()
    static let fontBold: UIFont = makeFont(size: 32.0, weight: .bold)
    static let fontBoldBig: UIFont = makeFont(size: 48.0, weight: .bold)
    static let fontSmallBold: UIFont = makeFont(size: 17.0, weight: .bold)
    static let fontSmall: UIFont = makeFont(size: 12.0, weight: .regular)
    static let fontWeeklyGoalSubtitle: UIFont = makeFont(size: 12, weight: .bold)
    static let fontExtraSmall: UIFont = makeFont(size: 10.0, weight: .semibold)
    static let fontClockCapitalised: UIFont = makeFont(size: 20.0, weight: .bold)
    static let fontClock: UIFont = makeFont(size: 18.0, weight: .regular)
    static let fontWeekTitle: UIFont = makeFont(size: 32, weight: .regular)

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
