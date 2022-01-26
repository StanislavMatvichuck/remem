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

    static let textSize: CGFloat = 24

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
        label.font = UIFont(name: "Nunito-Bold", size: textSize)
        label.numberOfLines = 1
        label.textColor = .systemBlue

        return label
    }()

    fileprivate var labelDay: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont(name: "Nunito", size: textSize)
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textColor = .label

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
            labelTime.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor),
            labelTime.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),

            labelDay.topAnchor.constraint(equalTo: viewRoot.topAnchor),
            labelDay.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),
            labelDay.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor),

            labelTime.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, multiplier: 1 / 3),
            labelDay.widthAnchor.constraint(equalTo: viewRoot.widthAnchor, multiplier: 2 / 3),
            
            labelTime.trailingAnchor.constraint(equalTo: labelDay.leadingAnchor),
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
