//
//  DayOfWeekCellView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import UIKit

final class DayOfWeekCellView: UIStackView {
    var viewModel: DayOfWeekCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private let percent: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        return label
    }()

    private let dayValue: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        return label
    }()

    private let dayName: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        return label
    }()

    private func configureLayout() {
        addArrangedSubview(percent)
        addArrangedSubview(dayValue)
        addArrangedSubview(dayName)
    }

    private func configureAppearance() {
        dayName.font = .font
        dayName.textColor = .secondary
    }

    private func configureContent(_ vm: DayOfWeekCellViewModel) {
        percent.text = "\(vm.percent)"
        dayValue.text = "\(vm.value)"
        dayName.text = vm.shortDayName
        percent.isHidden = vm.isHidden
        dayValue.isHidden = vm.isHidden
    }
}
