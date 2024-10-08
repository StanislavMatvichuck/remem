//
//  UIHelper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.06.2022.
//

import UIKit

extension UIImage {
    static let trash = UIImage(systemName: "trash.fill")!
    static let finger = UIImage(systemName: "hand.point.up.left")!
    static let minus = UIImage(systemName: "minus.circle.fill")!
    static let plus = UIImage(systemName: "plus.circle.fill")!
    static let qrCode = UIImage(systemName: "qr")!
}

extension CABasicAnimation {
    static let opacity = CABasicAnimation(keyPath: "opacity")
    static let positionX = CABasicAnimation(keyPath: "position.x")
    static let scale = CABasicAnimation(keyPath: "transform.scale")
}

extension UIColor {
    static let remem_primary = UIColor(named: "remem_primary")!
    static let remem_secondary = UIColor(named: "remem_secondary")!

    static let remem_bg = UIColor(named: "remem_bg")!
    static let bg_item = UIColor(named: "bg_item")!
    static let bg_primary = UIColor(named: "bg_primary")!
    static let bg_secondary = UIColor(named: "bg_secondary")!
    static let bg_secondary_dimmed = UIColor(named: "bg_secondary_dimmed")!
    static let bg_goal = UIColor(named: "bg_goal")!
    static let bg_goal_achieved = UIColor(named: "bg_goal_achieved")!
    static let bg_goal_achieved_dimmed = UIColor(named: "bg_goal_achieved_dimmed")!

    static let remem_text = UIColor(named: "remem_text")!
    static let text_goalAchieved = UIColor(named: "text_goalAchieved")!
    static let text_secondary = UIColor(named: "text_secondary")!
    static let remem_border = UIColor(named: "remem_border")!
    static let border_primary = UIColor(named: "border_primary")!
    static let border_secondary = UIColor(named: "border_secondary")!
}

extension CGFloat {
    static let screenW: CGFloat = UIScreen.main.bounds.width
    static let screenH: CGFloat = UIScreen.main.bounds.height
    static let layoutSquare: CGFloat = screenW / 7
    static let eventsListCellHeight: CGFloat = 2 * layoutSquare
    static let buttonHeight: CGFloat = eventsListCellHeight * 0.8
    static let buttonRadius: CGFloat = buttonHeight / 2
    static let buttonMargin: CGFloat = layoutSquare - buttonRadius
    static let swiperRadius: CGFloat = buttonRadius - buttonMargin
    static let border: CGFloat = 1.0
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
    static let fontExtraSmall: UIFont = makeFont(size: 10.0, weight: .regular)
    static let fontExtraSmallBold: UIFont = makeFont(size: 10.0, weight: .bold)
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
