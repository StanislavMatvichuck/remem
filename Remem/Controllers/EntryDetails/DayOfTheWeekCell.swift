//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

class DayOfTheWeekCell: UICollectionViewCell {
    //

    // MARK: - Static properties

    //

    static let reuseIdentifier = "CellDay"

    enum Kind {
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
        label.font = .systemFont(ofSize: .font1)
        label.textColor = .label
        label.text = " "

        return label
    }()

    fileprivate var labelAmount: UILabel = {
        let label = UILabel(frame: .zero)

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: .font1)
        label.textColor = .systemBlue
        label.text = " "

        return label
    }()

    fileprivate var viewIndicatorsContainer: UIStackView = {
        let view = UIStackView(frame: .zero)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = .delta1
        view.distribution = .fillEqually
        view.transform = CGAffineTransform(scaleX: 1, y: -1)

        for i in 1 ... 7 {
            let viewIndicator = UIView(frame: .zero)

            viewIndicator.translatesAutoresizingMaskIntoConstraints = false
            viewIndicator.backgroundColor = .systemBlue
            viewIndicator.alpha = 0
            viewIndicator.layer.cornerRadius = .delta1

            view.addArrangedSubview(viewIndicator)
        }

        return view
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
        viewRoot.addSubview(viewIndicatorsContainer)
        viewRoot.addSubview(labelAmount)
        viewRoot.addSubview(labelDay)

        let colWidth = .wScreen / 7

        NSLayoutConstraint.activate([
            // leading
            viewIndicatorsContainer.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .delta1),
            labelAmount.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor),
            labelDay.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor),
            // trailing
            viewIndicatorsContainer.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.delta1),
            labelAmount.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor),
            labelDay.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor),
            // top and bottom
            viewIndicatorsContainer.topAnchor.constraint(equalTo: viewRoot.topAnchor),

            labelAmount.topAnchor.constraint(equalTo: viewIndicatorsContainer.bottomAnchor, constant: .delta1),
            labelAmount.bottomAnchor.constraint(equalTo: labelDay.topAnchor),

            labelDay.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor),
            // heights

            labelDay.heightAnchor.constraint(equalToConstant: colWidth),
            labelAmount.heightAnchor.constraint(equalToConstant: colWidth),
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

    func update(day: String, isToday: Bool = false) {
        labelDay.text = day

        if isToday {
            labelDay.textColor = .systemBlue
        } else {
            labelDay.textColor = .label
        }
    }

    func update(amount: Int?) {
        disableAllIndicators()

        if amount == nil {
            labelAmount.text = " "
        } else {
            labelAmount.text = "\(amount!)"
            enableIndicators(amount: amount!)
        }
    }

    private func disableAllIndicators() {
        for subview in viewIndicatorsContainer.arrangedSubviews {
            subview.alpha = 0
        }
    }

    private func enableIndicators(amount: Int) {
        for (index, indicatorView) in viewIndicatorsContainer.arrangedSubviews.enumerated() {
            if index < amount {
                indicatorView.alpha = 1
            }
        }
    }
}
