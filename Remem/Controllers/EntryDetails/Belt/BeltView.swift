//
//  BeltView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class BeltView: UIView {
    // MARK: - Properties
    let scroll: ViewScroll = {
        let view = ViewScroll(.horizontal)

        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false

        view.viewContent.spacing = .sm
        // to place elements in the center of screen
        view.viewContent.layoutMargins = UIEdgeInsets(top: 0, left: .sm,
                                                      bottom: 0, right: .sm)
        view.viewContent.isLayoutMarginsRelativeArrangement = true

        // to fix vertical scrolling on x3 scale displays
        view.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0)
        return view
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addAndConstrain(scroll)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
