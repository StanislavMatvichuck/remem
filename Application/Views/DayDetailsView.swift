//
//  DayView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayDetailsView: UIView {
    static let margin: CGFloat = .buttonMargin / 1.2
    static let radius: CGFloat = margin * 2.6

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
        return table
    }()

    let picker: UIDatePicker = {
        let view = UIDatePicker(al: true)
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        return view
    }()

    let button: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: DayDetailsView.margin * 2, leading: 0, bottom: DayDetailsView.margin * 2, trailing: 0)
        let view = UIButton(configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleBackground: UIStackView = {
        let view = UIStackView(al: true)
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: DayDetailsView.margin * 2, left: DayDetailsView.margin, bottom: DayDetailsView.margin * 2, right: DayDetailsView.margin)
        view.setContentHuggingPriority(.defaultLow, for: .vertical)
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
        titleBackground.addArrangedSubview(title)
        verticalStack.addArrangedSubview(titleBackground)
        verticalStack.addArrangedSubview(happenings)
        verticalStack.addArrangedSubview(picker)
        verticalStack.addArrangedSubview(button)

        addAndConstrain(verticalStack)
    }

    private func configureAppearance() {
        backgroundColor = .bg_item
        clipsToBounds = true
        layer.cornerRadius = Self.radius

        picker.backgroundColor = .clear
        happenings.backgroundColor = .clear
        titleBackground.backgroundColor = .secondary
        button.layer.borderColor = UIColor.border_primary.cgColor
        button.layer.borderWidth = .border
        button.backgroundColor = .primary
    }

    private func configureTitle(viewModel: DayDetailsViewModel) {
        title.text = viewModel.title
        title.font = viewModel.isToday ? .fontBold : .font
    }

    private func configureButton(viewModel: DayDetailsViewModel) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.bg_item,
            .font: UIFont.font,
        ]

        let title = NSAttributedString(string: DayDetailsViewModel.create, attributes: attributes)

        button.setAttributedTitle(title, for: .normal)
    }
}
