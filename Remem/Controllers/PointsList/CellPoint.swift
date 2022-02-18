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
        label.font = .systemFont(ofSize: 16)
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
        label.font = .systemFont(ofSize: 16)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = .label
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViewRoot()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViewRoot() {
        viewRoot.addSubview(labelTime)
        viewRoot.addSubview(labelDay)

        NSLayoutConstraint.activate([
            labelTime.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            labelTime.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: 10),
            labelTime.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),

            labelDay.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            labelDay.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),
            labelDay.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: 10),

            labelTime.trailingAnchor.constraint(equalTo: labelDay.leadingAnchor, constant: -10),
        ])

        contentView.addAndConstrain(viewRoot)
    }

    //

    // MARK: - Behaviour

    //

    func update(time: String, day: String) {
        labelDay.text = day
        labelTime.text = time
    }
}
