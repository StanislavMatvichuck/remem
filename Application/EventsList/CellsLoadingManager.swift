//
//  CellsLoadingManager.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.05.2024.
//

import UIKit

protocol CellLoadingStopping {
    func stopLoading(for: UICollectionViewCell)
}

class CellsLoadingManager: CellLoadingStopping {
    private var loadingEventCells: [UICollectionViewCell: Task<Void, Never>] = [:]

    // TODO: get rid of concrete EventCell types
    func startLoading(for cell: UICollectionViewCell, factory: LoadableEventCellViewModelFactoring) {
        if
            let eventCell = cell as? EventCell,
            let viewModel = eventCell.viewModel,
            let eventId = viewModel.loadingArguments
        {
            let loadingTask = Task(priority: .userInitiated) { do {
                try Task.checkCancellation()

                let vm = try await factory.makeLoadedEventCellViewModel(eventId: eventId)

                await MainActor.run {
                    eventCell.viewModel = vm
                }
            } catch {} }

            loadingEventCells.updateValue(loadingTask, forKey: cell)
        }
    }

    func stopLoading(for cell: UICollectionViewCell) {
        if let loadingTask = loadingEventCells.removeValue(forKey: cell) {
            loadingTask.cancel()
        }
    }
}
