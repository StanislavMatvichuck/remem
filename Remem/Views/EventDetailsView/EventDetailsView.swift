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
        backgroundColor = .secondarySystemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        let scroll = ViewScroll(.vertical)
        scroll.contain(views: make(title: "By hours"))
        scroll.contain(views: clock)
        scroll.contain(views: make(title: "By days of week"))
        scroll.contain(views: week)

        addSubview(scroll)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func make(title: String) -> UIView {
        let label = UILabel(al: true)
        label.text = title
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont

        let view = UIView(al: true)
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        return view
    }
}
