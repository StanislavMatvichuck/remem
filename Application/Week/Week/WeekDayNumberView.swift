//
//  WeekDayNumberView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

import UIKit

final class WeekDayNumberView: UIView {
    private let number: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        return label
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    func configureContent(_ viewModel: WeekDayViewModel) {
        number.text = viewModel.dayNumber

        number.font = viewModel.isToday ? .fontBold : .font
        backgroundColor = viewModel.isDimmed ? .bg_primary : .primary
    }

    private func configureLayout() {
        addSubview(number)
        number.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        number.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }

    private func configureAppearance() {
        number.textColor = .bg_item
        backgroundColor = .primary
    }
}
