//
//  GoalsController+RemovableDropArea.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.04.2024.
//

import UIKit

extension GoalsController:
    UICollectionViewDragDelegate,
    UICollectionViewDropDelegate
{
    // MARK: - UICollectionViewDropDelegate
    func collectionView(_: UICollectionView, itemsForBeginning _: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        dragItems(indexPath)
    }

    func dragItems(_ indexPath: IndexPath) -> [UIDragItem] {
        let index = indexPath.row
        let provider = NSItemProvider(object: "\(index)" as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        viewModel?.dragAndDrop.startDragFor(eventIndex: index)
        return [dragItem]
    }

    // MARK: - UICollectionViewDropDelegate
    func collectionView(_: UICollectionView, performDropWith _: UICollectionViewDropCoordinator) {}
    func collectionView(_: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath indexPath: IndexPath?) -> UICollectionViewDropProposal {
        let locationX = session.location(in: viewRoot.removalDropArea).x
        viewRoot.removalDropArea.updateRemovalDropAreaPosition(x: locationX)

        let section = indexPath?.section
        if section == EventsListViewModel.Section.events.rawValue {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UICollectionViewDropProposal(operation: .cancel)
    }

    func collectionView(_: UICollectionView, dropSessionDidEnd _: UIDropSession) {
        viewModel?.dragAndDrop.endDrag()
    }
}
