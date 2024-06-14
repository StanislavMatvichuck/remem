//
//  SummaryContainer.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Domain
import UIKit

final class SummaryContainer: LoadableSummaryViewModelFactoring {
    let parent: EventDetailsContainer

    var event: Event { parent.event }
    var currentMoment: Date { parent.parent.currentMoment }

    init(_ parent: EventDetailsContainer) { self.parent = parent }

    func makeSummaryController() -> SummaryController {
        let list = SummaryView.makeList()
        let viewModel = makeViewModel()

        return SummaryController(
            view: makeSummaryView(list: list),
            viewModelFactory: self,
            dataSource: makeDataSource(list: list, viewModel: viewModel),
            loadingHandler: parent.parent.viewModelsLoadingHandler
        )
    }

    func makeViewModel() -> Loadable<SummaryViewModel> { Loadable<SummaryViewModel>() }

    func makeSummaryView(list: UICollectionView) -> SummaryView {
        SummaryView(list: list)
    }

    func makeDataSource(list: UICollectionView, viewModel: Loadable<SummaryViewModel>) -> SummaryDataSource { SummaryDataSource(
        list: list, viewModel: viewModel
    ) }

    func makeLoaded() async throws -> Loadable<SummaryViewModel> {
        let event = try await parent.parent.eventsReader.readAsync(byId: parent.eventId)
        let vm = SummaryViewModel(event: event, createdUntil: parent.parent.currentMoment)
        return Loadable<SummaryViewModel>(vm: vm)
    }
}
