//
//  WidgetUpdateService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.04.2024.
//

import Domain
import WidgetKit

struct WidgetServiceArgument { let viewModel: EventsListViewModel }

struct WidgetService: ApplicationService {
    func serve(_ arg: WidgetServiceArgument) {
        guard let directory = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.remem.io"
        ) else { return }

        let filePath = "RememWidgets.plist"
        let fileURL = directory.appendingPathComponent(filePath)

        let encoder = PropertyListEncoder()
        let eventsCellsIdentifiers = arg.viewModel.identifiersFor(section: .events)
        var writableItems = [WidgetEventCellViewModel]()

        eventsCellsIdentifiers.prefix(3).forEach {
            if
                let loadableVm = arg.viewModel.viewModel(forIdentifier: $0) as? LoadableEventCellViewModel,
                let eventVm = loadableVm.vm
            {
                writableItems.append(WidgetEventCellViewModel(item: eventVm))
            }
        }

        do {
            let dataToWrite = try encoder.encode(writableItems)
            try dataToWrite.write(to: fileURL)
            WidgetCenter.shared.reloadTimelines(ofKind: "RememWidgets")
        } catch {
            fatalError("unable to update widget \(fileURL.absoluteString) \(arg.viewModel) \(writableItems)")
        }
    }
}
