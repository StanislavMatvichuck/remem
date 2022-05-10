//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

class DayOfTheWeekCell: UICollectionViewCell {
    static let reuseIdentifier = "CellDay"

    enum Kind {
        case past
        case created
        case data
        case today
        case future
    }

    // MARK: - Properties
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
        let view = UIStackView(al: true)

        let indicatorSpacing = 5.0
        let indicatorHeight = (3.0 * .wScreen / 7.0 - 6.0 * indicatorSpacing) / 7

        view.axis = .vertical
        view.spacing = indicatorSpacing
        view.distribution = .fillEqually
        view.transform = CGAffineTransform(scaleX: 1, y: -1)

        for i in 1 ... 7 {
            let viewIndicator = UIView(al: true)
            viewIndicator.backgroundColor = .systemBlue
            viewIndicator.alpha = 0
            viewIndicator.layer.cornerRadius = indicatorHeight / 2

            let viewIndicatorPoint = UIView(al: true)
            viewIndicatorPoint.backgroundColor = .systemBackground
            viewIndicatorPoint.layer.cornerRadius = (indicatorHeight - 4) / 2
            viewIndicator.addSubview(viewIndicatorPoint)

            NSLayoutConstraint.activate([
                viewIndicatorPoint.widthAnchor.constraint(equalToConstant: indicatorHeight - 4),
                viewIndicatorPoint.heightAnchor.constraint(equalToConstant: indicatorHeight - 4),
                viewIndicatorPoint.trailingAnchor.constraint(equalTo: viewIndicator.trailingAnchor, constant: -2),
                viewIndicatorPoint.centerYAnchor.constraint(equalTo: viewIndicator.centerYAnchor),
            ])

            view.addArrangedSubview(viewIndicator)
        }

        return view
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addAndConstrain(viewRoot)
        setupViewRoot()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupViewRoot() {
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
}

// MARK: - Public
extension DayOfTheWeekCell {
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
}

// MARK: - Private
extension DayOfTheWeekCell {
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
