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

    fileprivate let viewOverlay: UIView = {
        let view = UIView(al: true)
        view.isHidden = true
        return view
    }()

    fileprivate let viewContainer: UIView = {
        let view = UIView(al: true)
        return view
    }()

    fileprivate let viewPointsList: UIView = {
        let view = UIView(al: true)
        return view
    }()

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        addAndConstrain(viewContainer)
        addAndConstrain(viewOverlay)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Behaviour

    //

    func contain(view: UIView) {
        viewContainer.addAndConstrain(view)
    }

    func install(overlay: UIView) {
        viewOverlay.addAndConstrain(overlay)
    }

    func showOverlay() {
        viewOverlay.isHidden = false
    }

    func hideOverlay() {
        viewOverlay.isHidden = true
    }
}
