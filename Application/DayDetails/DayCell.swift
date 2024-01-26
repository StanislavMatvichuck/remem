//
//  DayHappeningCell.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayCell: UICollectionViewCell {
    static let reuseIdentifier = "DayHappeningCell"
    static let margin: CGFloat = 2.5

    let label: UILabel = {
        let label = UILabel(al: true)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    var viewModel: DayCellViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    private let background: UIView = {
        let view = UIView(al: true)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        background.addAndConstrain(label, top: 0, left: Self.margin, right: Self.margin, bottom: 0)
        contentView.addAndConstrain(background, top: Self.margin, left: Self.margin)
    }

    private func configureAppearance() {
        backgroundColor = .clear
        label.textColor = UIColor.primary
        label.font = .fontSmallBold
        background.layer.backgroundColor = UIColor.border.cgColor
        background.layer.cornerRadius = .layoutSquare / 5
    }

    private func configureContent(_ vm: DayCellViewModel) { label.text = vm.time }
}
