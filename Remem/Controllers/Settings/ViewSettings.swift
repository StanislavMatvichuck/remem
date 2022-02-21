//
//  ViewSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class ViewSettings: UIView {
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
        super.init(frame: .zero)

        backgroundColor = .orange

//        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
