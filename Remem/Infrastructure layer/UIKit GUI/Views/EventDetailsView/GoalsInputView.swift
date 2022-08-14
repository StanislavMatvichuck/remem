//
//  GoalsInputView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import UIKit

class GoalsInputView: UIView {
    // MARK: - Properties
    let enabled: UISwitch = {
        let view = UISwitch(al: true)
        view.isOn = false
        view.preferredStyle = .checkbox
        return view
    }()

    let title: UILabel = {
        let label = UILabel(al: true)
        label.text = "Goal enabled"
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont
        return label
    }()

    let submit: UIView = {
        let label = UILabel(al: true)
        label.text = "Submit new goal"
        label.font = UIHelper.font
        label.textAlignment = .center

        let view = UIView(al: true)
        view.addAndConstrain(label)
        view.heightAnchor.constraint(equalToConstant: .d2).isActive = true
        view.layer.cornerRadius = .d2 / 2
        return view
    }()

    lazy var picker: UIPickerView = {
        let picker = UIPickerView(al: true)
        picker.backgroundColor = UIHelper.background
        picker.layer.cornerRadius = UIHelper.spacing / 2
        picker.dataSource = self
        return picker
    }()

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension GoalsInputView {
    private func setupLayout() {
        let titleContainer = UIStackView(al: true)
        titleContainer.axis = .horizontal
        titleContainer.addArrangedSubview(title)
        titleContainer.addArrangedSubview(enabled)

        let container = UIStackView(al: true)
        container.axis = .vertical
        container.spacing = UIHelper.spacing

        container.addArrangedSubview(titleContainer)
        container.addArrangedSubview(picker)
        container.addArrangedSubview(submit)

        addAndConstrain(container)
    }
}

// MARK: - Picker
extension GoalsInputView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Goal.WeekDay.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        20
    }
}
