//
//  ViewHappeningsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EventDetailsView: UIView {
    // MARK: - Properties

    let week = UIView(al: true)
    let happeningsList = UIView(al: true)
    let clock = UIView(al: true)

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        let scroll = ViewScroll(.vertical)
        addAndConstrain(scroll)
        scroll.contain(views: clock)
    }
}
