//
//  DayView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayDetailsView: UIView {
    private static let bg: UIColor = .background_secondary

    let verticalStack: UIStackView = {
        let view = UIStackView(al: true)
        view.axis = .vertical
        return view
    }()

    let title: UILabel = {
        let label = UILabel(al: true)
        label.textColor = .text_secondary
        return label
    }()

    let happenings: UITableView = {
        let table = UITableView(al: true)

        table.register(DayItem.self, forCellReuseIdentifier: DayItem.reuseIdentifier)
        table.separatorStyle = .none
        table.tableFooterView = UIView(al: true)
        table.allowsSelection = false
        table.backgroundColor = .clear

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
            view.axis = .horizontal
            view.backgroundColor = .secondary
            view.heightAnchor.constraint(equalToConstant: .layoutSquare).isActive = true
            view.isLayoutMarginsRelativeArrangement = true
            view.layoutMargins = UIEdgeInsets(top: 0, left: .buttonMargin, bottom: 0, right: .buttonMargin)
            view.addArrangedSubview(title)
            return view
        }()

        let pickerContainer: UIStackView = {
            let view = UIStackView(al: true)
            view.axis = .horizontal
            view.addArrangedSubview(picker)
            view.addArrangedSubview(button)
            view.distribution = .fillEqually
            view.heightAnchor.constraint(equalToConstant: .layoutSquare * 2).isActive = true
            return view
        }()

        verticalStack.addArrangedSubview(background)
        verticalStack.addArrangedSubview(happenings)
        verticalStack.addArrangedSubview(pickerContainer)
        addAndConstrain(verticalStack)
    }

    private func configureAppearance() {
        backgroundColor = Self.bg
        clipsToBounds = true
        layer.cornerRadius = .buttonMargin
    }

    private func configureTitle(viewModel: DayDetailsViewModel) {
        title.text = viewModel.title
        title.font = viewModel.isToday ? .fontBold : .font
    }

    private func configureButton(viewModel: DayDetailsViewModel) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.text_secondary,
            .font: UIFont.font
        ]

        let title = NSAttributedString(string: viewModel.create, attributes: attributes)

        button.setAttributedTitle(title, for: .normal)
    }
}
