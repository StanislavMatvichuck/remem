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

            if viewModel.titleHighlighted {
//                todo
            }
        }
    }

    let label: UILabel = {
        let label = UILabel(al: true)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        addSubview(label)
    }

    private func configureAppearance() {
        backgroundColor = .clear
    }

    override func prepareForReuse() {
        viewModel = nil
        super.prepareForReuse()
    }
}
