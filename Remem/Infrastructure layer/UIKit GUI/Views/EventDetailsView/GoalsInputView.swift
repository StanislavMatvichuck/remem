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
        label.font = UIHelper.font
        return label
    }()

    let submit: UIView = {
        let label = UILabel(al: true)
        label.text = "Submit new goal"
        label.font = UIHelper.font
        label.textColor = UIHelper.background
        label.textAlignment = .center

        let view = UIView(al: true)
        view.addAndConstrain(label)
        view.backgroundColor = UIHelper.brand
        view.heightAnchor.constraint(equalToConstant: .d2).isActive = true
        view.layer.cornerRadius = .d2 / 2

        return view
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

        let picker = makePickerView()

        let container = UIStackView(al: true)
        container.axis = .vertical
        container.addArrangedSubview(titleContainer)
        container.addArrangedSubview(picker)
        container.addArrangedSubview(submit)

        addAndConstrain(container)
    }

    private func makePickerView() -> UIPickerView {
        let picker = UIPickerView(al: true)
        picker.dataSource = self
        picker.delegate = self
        return picker
    }
}

// MARK: - Picker
extension GoalsInputView:
    UIPickerViewDataSource,
    UIPickerViewDelegate
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Goal.WeekDay.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        20
    }

    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String?
    {
        return "\(row)"
    }
}
