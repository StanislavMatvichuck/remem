//
//  CellCountableEventHappeningDescription.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class CountableEventHappeningDescriptionTimeCell: UITableViewCell {
    static let reuseIdentifier = "CellCountableEventHappeningDescription"

    // MARK: - Properties
    fileprivate var viewRoot: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate var labelTime: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIHelper.font
        label.textColor = UIHelper.brand
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()

    fileprivate var labelDay: UILabel = {
        let label = UILabel(frame: .zero)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupViewRoot()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    fileprivate func setupViewRoot() {
        viewRoot.addSubview(labelTime)
        viewRoot.addSubview(labelDay)
        contentView.addSubview(viewRoot)

        NSLayoutConstraint.activate([
            labelTime.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            labelTime.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .sm),
            labelTime.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),

            labelDay.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            labelDay.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),
            labelDay.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: .sm),

            labelTime.trailingAnchor.constraint(equalTo: labelDay.leadingAnchor, constant: -.sm),

            labelDay.widthAnchor.constraint(equalTo: labelTime.widthAnchor),

            viewRoot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewRoot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewRoot.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .sm / 2),
            viewRoot.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.sm / 2),
        ])
    }
}

// MARK: - Public
extension CountableEventHappeningDescriptionTimeCell {
    func update(time: String, day: String) {
        labelDay.text = day
        labelTime.text = time
    }
}
