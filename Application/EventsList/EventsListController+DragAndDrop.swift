//
//  EventsListViewController+DragAndDrop.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.02.2024.
//

import UIKit

extension EventsListController:
    UICollectionViewDragDelegate,
    UICollectionViewDropDelegate
{
    // MARK: - UICollectionViewDropDelegate
    func collectionView(_: UICollectionView, itemsForBeginning _: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        dragItems(indexPath)
    }

    func dragItems(_ indexPath: IndexPath) -> [UIDragItem] {
        let eventsSection = EventsListViewModel.Section.events.rawValue
        guard indexPath.section == eventsSection else { return [] }
        let eventIndex = indexPath.row
        let provider = NSItemProvider(object: "\(eventIndex)" as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        viewModel?.dragAndDrop.startDragFor(eventIndex: eventIndex)
        return [dragItem]
    }

    // MARK: - UICollectionViewDropDelegate
    func collectionView(_: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if let item = coordinator.items.first,
           let destination = coordinator.destinationIndexPath
        {
            coordinator.drop(item.dragItem, toItemAt: destination)
        }

        guard
            let viewModel,
            let from = viewModel.dragAndDrop.draggedCellIndex,
            let to = coordinator.destinationIndexPath?.row
        else { return }
        var eventsIdentifiers = viewModel.identifiersFor(section: .events)
        let movedEvent = eventsIdentifiers.remove(at: from)
        eventsIdentifiers.insert(movedEvent, at: to)
        handle(manualOrdering: eventsIdentifiers)
    }

    func collectionView(_: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath indexPath: IndexPath?) -> UICollectionViewDropProposal {
        viewRoot.removalDropArea.updateRemovalDropAreaPosition(x: session.location(in: viewRoot.removalDropArea).x)

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
