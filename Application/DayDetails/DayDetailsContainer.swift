//
//  DayDetailsContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2023.
//

import Domain
import UIKit

final class DayDetailsContainer:
    DayDetailsViewModelFactoring
//    DayCellViewModelFactoring
{
    let parent: EventDetailsContainer
    let startOfDay: Date

    init(_ parent: EventDetailsContainer, startOfDay: Date) {
        self.parent = parent
        self.startOfDay = startOfDay
    }

    func makeDayDetailsController() -> DayDetailsController {
        let list = DayDetailsView.makeList()
        let viewModel = makeDayDetailsViewModel(pickerDate: nil)

        return DayDetailsController(
            self,
            createHappeningService: makeCreateHappeningService(),
            removeHappeningService: makeRemoveHappeningService(),
            view: makeView(list: list, viewModel: viewModel),
            dataSource: makeDataSource(list: list, viewModel: viewModel)
        )
    }

    func makeView(list: UICollectionView, viewModel: DayDetailsViewModel) -> DayDetailsView { DayDetailsView(
        list: list,
        viewModel: viewModel
    ) }

    func makeDayDetailsViewModel(pickerDate: Date?) -> DayDetailsViewModel {
        DayDetailsViewModel(
            currentMoment: parent.parent.currentMoment,
            startOfDay: startOfDay,
            pickerDate: pickerDate,
            eventsReader: parent.parent.eventsReader,
            eventId: parent.eventId
        )
    }

    func makeDataSource(list: UICollectionView, viewModel: DayDetailsViewModel) -> DayDetailsDataSource { DayDetailsDataSource(
        list: list,
        viewModel: viewModel
    ) }

//    func makeDayCellViewModel(happening: Happening) -> DayCellViewModel { DayCellViewModel(
//        id: UUID(),
//        happening: happening
//    ) }

    func makeCreateHappeningService() -> CreateHappeningService { CreateHappeningService(
        eventsStorage: parent.parent.eventsWriter,
        eventsProvider: parent.parent.eventsReader
    ) }

    func makeRemoveHappeningService() -> RemoveHappeningService { RemoveHappeningService(
        eventId: parent.eventId,
        eventsStorage: parent.parent.eventsWriter,
        eventsProvider: parent.parent.eventsReader
    ) }
}
