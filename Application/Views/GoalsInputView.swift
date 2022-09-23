//
//  GoalsInputView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import UIKit

class GoalsInputView: UIView {
    // MARK: - Properties
    let picker: UIPickerView = {
        let picker = UIPickerView(al: true)
        picker.backgroundColor = UIHelper.background
        picker.layer.cornerRadius = UIHelper.spacing / 2
        return picker
    }()

    let viewModel: GoalsInputViewModel

    // MARK: - Init
    init(viewModel: GoalsInputViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        picker.dataSource = self
        addAndConstrain(picker)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func makePickerLabel(forRow: Int) -> UILabel {
        let label = UILabel()
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        label.textAlignment = .center
        label.text = "\(forRow)"
        return label
    }
}

// MARK: - Picker
extension GoalsInputView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 7 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { WeekCell.sectionsAmount + 1 }
}
