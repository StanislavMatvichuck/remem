//
//  EventsListView+Drop.swift
//  Application
//
//  Created by Stanislav Matvichuck on 19.02.2024.
//

import UIKit

extension EventsListView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        viewModel?.activateDropArea()
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        viewModel?.deactivateDropArea()
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard
            let viewModel,
            let draggedCellIndex = viewModel.draggedCellIndex
        else { return }
        let eventCellsIdentifiers = viewModel.identifiersFor(section: .events)
        let cellIdentifier = eventCellsIdentifiers[draggedCellIndex]
        if let cell = list.cellForItem(at: IndexPath(row: draggedCellIndex, section: 1)) as? EventCell {
            cell.removeService?.serve(RemoveEventServiceArgument(eventId: cellIdentifier))
        }
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal { UIDropProposal(operation: .move) }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool { true }
}
