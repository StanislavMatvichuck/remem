//
//  GoalsInputView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 14.08.2022.
//

import UIKit

class GoalsInputView: UIView {
    // MARK: - Properties
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
        addAndConstrain(picker)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Picker
extension GoalsInputView: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        Goal.WeekDay.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { WeekCell.sectionsAmount + 1 }
}
