//
//  DayView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayDetailsView: UIView {
    private static let bg: UIColor = .clear

    let verticalStack: UIStackView = {
        let view = UIStackView(al: true)
        view.axis = .vertical
        return view
    }()

    let title: UILabel = {
        let label = UILabel(al: true)
        label.textColor = .bg
        label.textAlignment = .center
        return label
    }()

    let happenings: UITableView = {
        let table = UITableView(al: true)
        table.register(DayCell.self, forCellReuseIdentifier: DayCell.reuseIdentifier)
        table.separatorStyle = .none
        table.tableFooterView = nil
        table.allowsSelection = false
        table.backgroundColor = .clear
        table.backgroundColor = .bg_item
        return table
    }()

    let picker: UIDatePicker = {
        let view = UIDatePicker(al: true)
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.backgroundColor = bg
        return view
    }()

    let button: UIButton = {
        let view = UIButton(al: true)
        view.backgroundColor = .primary
        return view
    }()

    init(viewModel: DayDetailsViewModel) {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
        configure(viewModel: viewModel)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(viewModel: DayDetailsViewModel) {
        configureTitle(viewModel: viewModel)
        configureButton(viewModel: viewModel)
        picker.date = viewModel.pickerDate
        happenings.reloadData()
    }

    private func configureLayout() {
        let background: UIView = {
            let view = UIStackView(al: true)
            view.backgroundColor = .secondary
            view.isLayoutMarginsRelativeArrangement = true
            view.layoutMargins = UIEdgeInsets(top: .buttonMargin * 2, left: .buttonMargin, bottom: .buttonMargin * 2, right: .buttonMargin)
            view.addArrangedSubview(title)
            return view
        }()

        let pickerContainer: UIStackView = {
            let view = UIStackView(al: true)
            view.axis = .horizontal
            view.addArrangedSubview(picker)
            view.addArrangedSubview(button)
            view.distribution = .fillEqually
            view.backgroundColor = .bg_item
            return view
        }()

        background.setContentHuggingPriority(.defaultLow, for: .vertical)

        verticalStack.addArrangedSubview(background)
        verticalStack.addArrangedSubview(happenings)
        verticalStack.addArrangedSubview(pickerContainer)
        addAndConstrain(verticalStack)

        NSLayoutConstraint.activate([
            pickerContainer.heightAnchor.constraint(equalToConstant: .layoutSquare * 2),
        ])
    }

    private func configureAppearance() {
        backgroundColor = Self.bg
        clipsToBounds = true
        layer.cornerRadius = .buttonMargin

        button.layer.cornerRadius = .buttonMargin
        button.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]

        button.layer.borderColor = UIColor.border_primary.cgColor
        button.layer.borderWidth = .border
    }

    private func configureTitle(viewModel: DayDetailsViewModel) {
        title.text = viewModel.title
        title.font = viewModel.isToday ? .fontBold : .font
    }

    private func configureButton(viewModel: DayDetailsViewModel) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.bg,
            .font: UIFont.font,
        ]

        let title = NSAttributedString(string: DayDetailsViewModel.create, attributes: attributes)

        button.setAttributedTitle(title, for: .normal)
        button.titleLabel?.numberOfLines = 3
    }
}
