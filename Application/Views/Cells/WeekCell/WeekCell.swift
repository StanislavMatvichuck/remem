//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

final class WeekCell: UICollectionViewCell {
    static let reuseIdentifier = "WeekItem"

    static let layoutSize: CGSize = {
        CGSize(width: .layoutSquare, height: .layoutSquare * 3)
    }()

    let view = WeekCellView()
    var viewModel: WeekCellViewModel? { didSet {
        guard let viewModel else { return }
        view.configureContent(viewModel)
    }}

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        contentView.addAndConstrain(view)
    }

    // MARK: - View lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        view.prepareForReuse()
    }
}
