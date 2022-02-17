//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

class CellDay: UICollectionViewCell {
    //

    // MARK: - Static properties

    //

    static let reuseIdentifier = "CellDay"

    enum type {
        case past
        case created
        case data
        case today
        case future
    }

    //

    // MARK: - Private properties

    //

    fileprivate var viewRoot: UIView = {
        let view = UIView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    fileprivate var labelDay: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "Nunito", size: 24)
        label.textColor = .label
        label.text = ""

        return label
    }()

    fileprivate var labelAmount: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont(name: "Nunito", size: 24)
        label.textColor = .label
        label.text = ""

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addAndConstrain(viewRoot)

        setupViewRoot()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupViewRoot() {
        viewRoot.addSubview(labelDay)
        viewRoot.addSubview(labelAmount)

        NSLayoutConstraint.activate([
            labelDay.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),
            labelDay.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor),
            labelDay.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor),

            labelAmount.bottomAnchor.constraint(equalTo: labelDay.topAnchor),
            labelAmount.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor),
            labelAmount.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor),
        ])

        contentView.addAndConstrain(viewRoot)
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = .systemBackground
    }

    //

    // MARK: - Behaviour

    //

    func update(day: String) {
        labelDay.text = day
    }

    func update(amount: Int?) {
        if amount == nil {
            labelAmount.text = ""
        } else {
            labelAmount.text = "\(amount!)"
        }
    }
}
