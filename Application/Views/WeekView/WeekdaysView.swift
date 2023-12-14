//
//  WeekdaysView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 08.05.2023.
//

import UIKit

final class WeekdaysView: UIStackView {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        let formatter = DateFormatter()
        var days = formatter.veryShortWeekdaySymbols!

        days = Array(days[1..<days.count]) + days[0..<1]

        for day in days {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = day
            label.textAlignment = .center
            label.font = .fontSmallBold
            label.textColor = UIColor.secondary

            addArrangedSubview(label)
        }
    }

    private func configureAppearance() {}
}
