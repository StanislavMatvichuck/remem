//
//  Metrics.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

extension CGFloat {
    // MARK: Relative unit definition
    static var rem: CGFloat = {
        let width: CGFloat = UIScreen.main.bounds.width

        if width >= 768 {
            return 23.0 // ipad
        } else if width >= 414 {
            return 18.0 // 8+, XR, XR max
        } else if width >= 375 {
            return 15.0 // 6, 6+, 8
        } else if width >= 320 {
            return 14.0 // SE, 5
        }

        return 12.0 // not used
    }()

    // MARK: Main metrics
    static var xs: CGFloat { rem / 2 }
    static var sm: CGFloat { rem }
    static var md: CGFloat { 1.8 * rem }
    static var lg: CGFloat { 3 * rem }
    // MARK: Screen size
    static var wScreen: CGFloat { UIScreen.main.bounds.width }
    static var hScreen: CGFloat { UIScreen.main.bounds.height }
    // MARK: Fonts
    static var font1: CGFloat { UIFont.labelFontSize }
    static var font2: CGFloat { 2 * .font1 }
    // MARK: Extras
    static var hairline: CGFloat { return 1.0 / UIScreen.main.scale }

    // MARK: - Remem specific layout
    static var r1: CGFloat { 2 * rem }
    static var r2: CGFloat { r1 + .delta1 }
    static var delta1: CGFloat { .xs }
    static var d1: CGFloat { 2 * r1 }
    static var d2: CGFloat { 2 * r2 }
}
