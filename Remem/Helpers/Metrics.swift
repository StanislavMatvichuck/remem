//
//  Metrics.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

extension CGFloat {
    // MARK: Relative unit definition

    static var rem: CGFloat {
        let screen: CGRect = UIScreen.main.bounds

        if screen.width >= 768 {
            return 23.0 // ipad
        } else if screen.width >= 414 {
            return 18.0 // 8+, XR, XR max
        } else if screen.width >= 375 {
            return 15.0 // 6, 6+, 8
        } else if screen.width >= 320 {
            return 14.0 // SE, 5
        }

        return 12.0 // not used
    }

    // MARK: Main metrics

    static var xs: CGFloat { return rem / 2 }
    static var sm: CGFloat { return rem }
    static var md: CGFloat { return 1.8 * rem }
    static var lg: CGFloat { return 3 * rem }

    // MARK: Screen size

    static var wScreen: CGFloat { return UIScreen.main.bounds.width }
    static var hScreen: CGFloat { return UIScreen.main.bounds.height }

    // MARK: Fonts

    static var font1: CGFloat { return 0.8 * rem }
    static var font2: CGFloat { return 1.0 * rem }
    static var font3: CGFloat { return 1.3 * rem }
    static var font4: CGFloat { return 1.6 * rem }
    static var font5: CGFloat { return 2.0 * rem }
    static var font6: CGFloat { return 2.2 * rem }

    // MARK: Extras

    static var hairline: CGFloat { return 1.0 / UIScreen.main.scale }
    static var hInput: CGFloat { return 3 * rem }
    static var hButton: CGFloat { return 3.2 * rem }
}
