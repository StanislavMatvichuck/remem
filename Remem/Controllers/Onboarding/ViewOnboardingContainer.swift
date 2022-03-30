//
//  ViewOnboardingContainer.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.03.2022.
//

import UIKit

class ViewOnboardingContainer: UIView {
    //

    // MARK: - Private properties

    //

    let viewOverlay: UIView = {
        let view = UIView(al: true)
        view.isHidden = true
        return view
    }()

    let viewMain: UIView = {
        let view = UIView(al: true)
        return view
    }()

    let viewPointsList: UIView = {
        let view = UIView(al: true)
        view.isHidden = true
        return view
    }()

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        addAndConstrain(viewMain)
        addAndConstrain(viewOverlay)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
