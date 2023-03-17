//
//  ViewHappeningsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EventDetailsView: UIView {
    // MARK: - Properties
    let scroll: ViewScroll

    // MARK: - Init
    init() {
        self.scroll = ViewScroll(.vertical)
        super.init(frame: .zero)
        backgroundColor = UIColor.background
        configureLayout()
    }

    private func configureLayout() {
        addAndConstrain(scroll)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
