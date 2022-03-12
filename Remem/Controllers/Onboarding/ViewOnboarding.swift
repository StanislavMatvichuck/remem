//
//  ViewOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class ViewOnboarding: UIView {
    //

    // MARK: - Public properties

    //

    //

    // MARK: - Private properties

    //

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: .wScreen, height: .hScreen))
        layer.backgroundColor = UIColor.orange.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Touches transparency with children capturing

    //

    /// This property enables touches to be passed through this view but not its siblings
    /// used together with hitTest override
    var isTransparentForTouches = false

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)

        if isTransparentForTouches {
            if !subviews.filter({ $0 == view }).isEmpty {
                return subviews.filter { $0 == view }.first!
            } else {
                return nil
            }
        }

        return super.hitTest(point, with: event)
    }
}
