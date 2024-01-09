//
//  DayView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayDetailsView: UIView {
    static let margin: CGFloat = .buttonMargin / 1.2
    static let radius: CGFloat = margin * 2.6

    let verticalStack: UIStackView = {
        let view = UIStackView(al: true)
        view.axis = .vertical
        return view
    }()

    let title: UILabel = {
        let label = UILabel(al: true)
        label.textColor = .bg
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    let titleBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    let happeningsCollection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumInteritemSpacing = 0.0
        collectionLayout.minimumLineSpacing = 0.0

        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        collection.widthAnchor.constraint(equalTo: collection.heightAnchor).isActive = true
        return collection
    }()

    let picker: UIDatePicker = {
        let view = UIDatePicker(al: true)
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        return view
    }()

    let button: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        label.textColor = .bg_item
        label.text = DayDetailsViewModel.create
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    let buttonBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    var viewModel: DayDetailsViewModel? { didSet {
        guard let viewModel else { return }
        configure(viewModel: viewModel)
    }}

    init() {
        super.init(frame: .zero)
        happeningsCollection.dataSource = self
        configureLayout()
        configureAppearance()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(viewModel: DayDetailsViewModel) {
        configureTitle(viewModel: viewModel)
        picker.date = viewModel.pickerDate
        happeningsCollection.reloadData()
    }

    private func configureLayout() {
        titleBackground.addAndConstrain(title)
        buttonBackground.addAndConstrain(button)

        verticalStack.addArrangedSubview(titleBackground)
        verticalStack.addArrangedSubview(happeningsCollection)
        verticalStack.addArrangedSubview(picker)
        verticalStack.addArrangedSubview(buttonBackground)

        titleBackground.heightAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 1 / 4).isActive = true
        buttonBackground.heightAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 1 / 4).isActive = true

        addAndConstrain(verticalStack)
    }

    private func configureAppearance() {
        backgroundColor = .bg_item
        clipsToBounds = true
        layer.cornerRadius = Self.radius

        picker.backgroundColor = .clear
        titleBackground.backgroundColor = .secondary
        buttonBackground.backgroundColor = .primary
    }

    private func configureTitle(viewModel: DayDetailsViewModel) {
        title.text = viewModel.title
        title.font = viewModel.isToday ? .fontBold : .font
    }
}

extension DayDetailsView: UICollectionViewDataSource {
    var viewModelErrorMessage: String { "view requires viewModel to display" }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.cellsCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let viewModel,
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DayCell.reuseIdentifier,
                for: indexPath
            ) as? DayCell
        else { fatalError(viewModelErrorMessage) }
        cell.viewModel = viewModel.cellAt(index: indexPath.row)
        return cell
    }
}
