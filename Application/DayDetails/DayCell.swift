//
//  DayHappeningCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayCell: UICollectionViewCell {
    static let reuseIdentifier = "DayHappeningCell"

    let label: UILabel = {
        let label = UILabel(al: true)
        label.numberOfLines = 1
        label.font = .font
        label.textAlignment = .center
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    var viewModel: DayCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        contentView.addAndConstrain(label, constant: DayDetailsView.margin)
    }

    private func configureAppearance() {
        backgroundColor = .clear
        label.textColor = UIColor.text
    }

    private func configureContent(_ vm: DayCellViewModel) { label.text = vm.time }
}
