//
//  DayView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import UIKit

final class DayDetailsView: UIView, DayDetailsDataProviding {
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
        let collection = UICollectionView(frame: .zero, collectionViewLayout: DayDetailsView.makeLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.widthAnchor.constraint(equalTo: collection.heightAnchor).isActive = true
        collection.isAccessibilityElement = true
        collection.accessibilityIdentifier = UITestAccessibilityIdentifier.dayDetailsHappeningsList.rawValue
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
        label.isAccessibilityElement = true
        label.accessibilityIdentifier = UITestAccessibilityIdentifier.dayDetailsAddHappening.rawValue
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
        dataSource.applySnapshot(oldValue)
    }}

    lazy var dataSource = DayDetailsDataSource(list: happeningsCollection, provider: WeakRef(self))

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

        addAndConstrain(verticalStack)
    }

    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 4), heightDimension: .fractionalWidth(1.0 / 4))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 4))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: DayCell.margin / 2)
            return section
        }
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
