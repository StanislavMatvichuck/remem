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

    let delete: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        label.textColor = .bg_item
        label.text = DayDetailsViewModel.delete
        label.textAlignment = .center
        label.numberOfLines = 1
        label.layer.opacity = 0
        return label
    }()

    let buttonBackground: UIView = {
        let view = UIView(al: true)
        return view
    }()

    var viewModel: DayDetailsViewModel? { didSet {
        guard let viewModel else { return }
        configure(viewModel: viewModel)
        dataSource.viewModel = viewModel
    }}

    lazy var dataSource = DayDetailsDataSource(happeningsCollection)

    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(viewModel: DayDetailsViewModel) {
        configureTitle(viewModel: viewModel)
        picker.date = viewModel.pickerDate
        animateFor(viewModel.animation)
    }

    private let duration = TimeInterval(0.5)

    private func animateFor(_ animation: DayDetailsViewModel.Animation?) {
        switch animation {
        case nil:
            UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.buttonBackground.backgroundColor = .primary
                })

                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.button.layer.opacity = 1
                    self.delete.layer.opacity = 0
                })
            })
        case .deleteDropArea:
            UIView.animateKeyframes(withDuration: duration, delay: 0, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                    self.buttonBackground.backgroundColor = .red
                })
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                    self.button.layer.opacity = 0
                    self.delete.layer.opacity = 1
                })
            })
        }
    }

    private func configureLayout() {
        titleBackground.addAndConstrain(title)
        buttonBackground.addAndConstrain(button)
        buttonBackground.addAndConstrain(delete)

        verticalStack.addArrangedSubview(titleBackground)
        verticalStack.addArrangedSubview(happeningsCollection)
        verticalStack.addArrangedSubview(picker)
        verticalStack.addArrangedSubview(buttonBackground)

        titleBackground.heightAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 1 / 4).isActive = true
        buttonBackground.heightAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 1 / 4).isActive = true

        happeningsCollection.trailingAnchor.constraint(equalTo: verticalStack.trailingAnchor, constant: -DayCell.margin).isActive = true
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
