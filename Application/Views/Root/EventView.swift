//
//  ViewHappeningsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EventView: UIView {
    // MARK: - Properties
    let scroll: ViewScroll

    // MARK: - Init
    init() {
        self.scroll = ViewScroll(.vertical)
        super.init(frame: .zero)
        backgroundColor = UIHelper.background
        configureLayout()
    }

    private func configureLayout() {
        let spacing = UIView(al: true)
        spacing.backgroundColor = .clear

        scroll.contain(views: spacing)

        addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            spacing.heightAnchor.constraint(equalToConstant: UIHelper.spacingListHorizontal)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
