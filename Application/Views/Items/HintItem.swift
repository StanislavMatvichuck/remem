//
//  HintItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit

class HintItem: UITableViewCell, EventsListCell {
    static var reuseIdentifier = "HintItem"

    var viewModel: HintItemViewModel? {
        didSet {
            guard let viewModel else { return }

            label.text = viewModel.title
            label.textColor = UIColor.secondary

            if viewModel.highlighted { label.font = UIHelper.fontBold }
            else { label.font = UIHelper.fontSmall }
        }
    }

    let label: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIHelper.spacing),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIHelper.spacing),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * UIHelper.spacingListHorizontal),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }

    private func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }
}
