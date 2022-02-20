//
//  CellPoint.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class CellPoint: UITableViewCell {
    //

    // MARK: - Static properties

    //

    static let reuseIdentifier = "CellPoint"

    //

    // MARK: - Private properties

    //

    fileprivate var viewRoot: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    fileprivate var labelTime: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: .font1)
        label.numberOfLines = 1
        label.textColor = .systemBlue
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        return label
    }()

    fileprivate var labelDay: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: .font1)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = .label
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        setupViewRoot()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViewRoot() {
        viewRoot.addSubview(labelTime)
        viewRoot.addSubview(labelDay)
        contentView.addSubview(viewRoot)

        NSLayoutConstraint.activate([
            labelTime.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            labelTime.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .delta1),
            labelTime.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),

            labelDay.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            labelDay.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),
            labelDay.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: .delta1),

            labelTime.trailingAnchor.constraint(equalTo: labelDay.leadingAnchor, constant: -.delta1),

            viewRoot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewRoot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            viewRoot.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .delta1 / 2),
            viewRoot.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.delta1 / 2),
        ])
    }

    //

    // MARK: - Behaviour

    //

    func update(time: String, day: String) {
        labelDay.text = day
        labelTime.text = time
    }
}
