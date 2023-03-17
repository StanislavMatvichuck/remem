//
//  CellDay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.02.2022.
//

import UIKit

class WeekItem: UICollectionViewCell {
    static let reuseIdentifier = "WeekItem"
    static let spacing = UIHelper.spacing / 8
    static let happeningsDisplayedMaximumAmount = 7
    static let layoutSize: CGSize = {
        let screenW = UIScreen.main.bounds.width

        let size = CGSize(
            width: screenW / 7,
            height: UIView.layoutFittingCompressedSize.height
        )

        let layoutSize = WeekItem().systemLayoutSizeFitting(
            size,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return CGSize(width: size.width, height: layoutSize.height)
    }()

    var viewModel: WeekItemViewModel! { didSet { configureContent() } }

    let day: UILabel = {
        let label = UILabel(al: true)
        label.font = UIHelper.fontSmallBold
        label.backgroundColor = UIColor.primary
        label.textColor = UIColor.text_secondary
        label.textAlignment = .center
        label.text = " "
        label.widthAnchor.constraint(equalTo: label.heightAnchor).isActive = true
        return label
    }()

    let timingLabels: [UILabel] = {
        func makeTimeLabel() -> UILabel {
            let newLabel = UILabel(al: true)
            newLabel.textAlignment = .center
            newLabel.font = UIHelper.fontSmallBold
            newLabel.textColor = UIColor.text_primary
            newLabel.adjustsFontSizeToFitWidth = true
            newLabel.minimumScaleFactor = 0.1
            newLabel.numberOfLines = 1
            newLabel.backgroundColor = .clear
            newLabel.text = " "
            return newLabel
        }

        var result = [UILabel]()

        for _ in 0 ..< WeekItem.happeningsDisplayedMaximumAmount { result.append(makeTimeLabel()) }

        return result
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configureLayout() {
        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = UIColor.background_secondary
        stack.layer.cornerRadius = UIHelper.radius
        stack.clipsToBounds = true

        for timingLabel in timingLabels.reversed() {
            stack.addArrangedSubview(timingLabel)
        }

        stack.addArrangedSubview(day)
        stack.addArrangedSubview(UIView(al: true))

        contentView.addAndConstrain(stack, left: Self.spacing, right: Self.spacing, bottom: Self.spacing)
    }

    // MARK: - View lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
        hideAll()
        day.text = " "
    }

    private func configureContent() {
        guard let viewModel = viewModel else { return }

        day.text = viewModel.dayNumber
        day.font = viewModel.isToday ? UIHelper.fontBold : UIHelper.font

        show(timings: viewModel.items)
    }

    private func show(timings: [String]) {
        hideAll()

        let displayedTimes = timings.suffix(Self.happeningsDisplayedMaximumAmount).enumerated()

        for (index, time) in displayedTimes {
            timingLabels[index].text = time
        }
    }

    private func hideAll() {
        for timingLabel in timingLabels { timingLabel.text = " " }
    }
}
