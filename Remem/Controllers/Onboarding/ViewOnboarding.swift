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
}
