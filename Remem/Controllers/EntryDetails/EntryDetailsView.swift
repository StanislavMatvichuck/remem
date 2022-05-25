//
//  ViewPointsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class EntryDetailsView: UIView {
    // MARK: - Properties

    let time: ViewScroll = {
        let view = ViewScroll(.horizontal)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    let week = UIView(al: true)
    let pointsList = UIView(al: true)
    let belt = UIView(al: true)
    let clock = UIView(al: true)

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        time.contain(views: clock, pointsList)

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.addArrangedSubview(time)
        stack.addArrangedSubview(belt)
        stack.addArrangedSubview(week)

        addSubview(stack)
        NSLayoutConstraint.activate([
            clock.widthAnchor.constraint(equalTo: widthAnchor),
            pointsList.widthAnchor.constraint(equalTo: widthAnchor),

            stack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
