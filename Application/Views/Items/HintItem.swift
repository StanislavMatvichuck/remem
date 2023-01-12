//
//  HintItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.01.2023.
//

import UIKit
// TODO: explore why importing UIKit replaces importing Foundation. How to apply it to Domain lib?

class HintItem: UITableViewCell {
    var viewModel: HintItemViewModel? {
        didSet {
            guard let viewModel else { return }

            label.text = viewModel.title

            if viewModel.highlighted {
                label.font = UIHelper.fontBold
                label.textColor = UIHelper.itemFont
            } else {
                label.font = UIHelper.fontSmallBold
                label.textColor = UIHelper.hint
            }
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
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
