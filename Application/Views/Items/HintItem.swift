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

            if viewModel.highlighted { label.font = .fontBold }
            else { label.font = .fontSmall }
        }
    }

    let label: UILabel = {
        let label = UILabel(al: true)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
//        installDotsPattern()

        contentView.addSubview(label)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -2 * .buttonMargin),
            label.heightAnchor.constraint(equalToConstant: .layoutSquare),
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
