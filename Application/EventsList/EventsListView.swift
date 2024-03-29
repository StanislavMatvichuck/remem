//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

final class EventsListView: UIView {
    static let removalDropAreaDefaultOpacity: Float = 0.5
    
    let list: UICollectionView
    let dataSource: EventsListDataSource
    
    let removalDropArea: UIView = {
        let view = UIView(al: true)
        let image = UIImage(systemName: "trash.fill")?
            .withTintColor(UIColor.bg)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))
        let imageView = UIImageView(al: true)
        imageView.image = image
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.buttonMargin).isActive = true
        return view
    }()
    
    var viewModel: EventsListViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
        dataSource.applySnapshot(oldValue)
    }}
    
    lazy var animatedConstraint: NSLayoutConstraint = { removalDropArea.trailingAnchor.constraint(equalTo: leadingAnchor) }()
    
    init(list: UICollectionView, dataSource: EventsListDataSource) {
        self.list = list
        self.dataSource = dataSource
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
        configureDropArea()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateRemovalDropAreaPosition(x: CGFloat) {
        let constant = (bounds.width - x) / 3
        
        let lowerBound = CGFloat.buttonMargin
        let upperBound = removalDropArea.bounds.width - 2 * removalDropArea.layer.cornerRadius
        let clampedConstant = constant.clamped(to: lowerBound ... upperBound)
        
        animatedConstraint.constant = clampedConstant
    }
    
    func startHintAnimationIfNeeded() {
//        guard
//            let viewModel,
//            let eventsSection = viewModel.sections.first(where: { section in
//                section == .events
//            }),
//            viewModel.cellsIdentifiers(for: .events).count > 0
//        else { return }
//
//        let firstEventCellIndexPath = IndexPath(
//            row: 0,
//            section: eventsSection.rawValue
//        )
//
//        guard
//            let eventCell = list.cellForItem(
//                at: firstEventCellIndexPath
//            ) as? EventCell
//        else { return }
//
//        eventCell.view.hintDisplay.startAnimationIfNeeded()
    }
    
    static func makeList() -> UICollectionView {
        let list = UICollectionView(frame: .zero, collectionViewLayout: EventsListView.makeLayout())
        list.translatesAutoresizingMaskIntoConstraints = false
        return list
    }
    
    private static func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let heightDimension: NSCollectionLayoutDimension = .estimated(.eventsListCellHeight)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: heightDimension)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = .buttonMargin
            section.contentInsets = NSDirectionalEdgeInsets(
                top: .buttonMargin, leading: 0,
                bottom: .buttonMargin, trailing: 0
            )
            return section
        }
    }
    
    // MARK: - Private
    
    private func configureLayout() {
        addAndConstrain(list)
        
        addSubview(removalDropArea)
        removalDropArea.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3).isActive = true
        removalDropArea.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, constant: -2 * .buttonMargin).isActive = true
        animatedConstraint.isActive = true
        removalDropArea.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
    }
    
    private func configureAppearance() {
        list.backgroundColor = .clear
        
        backgroundColor = .bg
        removalDropArea.backgroundColor = UIColor.red
        removalDropArea.layer.cornerRadius = CGFloat.buttonMargin
        removalDropArea.isHidden = true
        removalDropArea.layer.opacity = Self.removalDropAreaDefaultOpacity
    }
    
    private func configureContent(_ viewModel: EventsListViewModel) {
        removalDropArea.isHidden = viewModel.removalDropAreaHidden
        removalDropArea.layer.opacity = viewModel.removalDropAreaActive ?
            1.0 :
            Self.removalDropAreaDefaultOpacity
    }
    
    private func configureDropArea() {
        let dropInteraction = UIDropInteraction(delegate: self)
        removalDropArea.addInteraction(dropInteraction)
    }
}
