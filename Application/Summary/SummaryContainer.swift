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

    func makeSummaryController() -> SummaryController { SummaryController(
        view: makeSummaryView(),
        viewModelFactory: self,
        loadingHandler: parent.parent.viewModelsLoadingHandler
    ) }

    func makeSummaryView() -> SummaryView {
        let list = SummaryView.makeList()
        let dataSource = SummaryDataSource(list: list)
        return SummaryView(list: list, dataSource: dataSource)
    }

    func makeLoading() -> Loadable<SummaryViewModel> { Loadable<SummaryViewModel>() }
    func makeLoaded() async throws -> Loadable<SummaryViewModel> {
        let event = try await parent.parent.provider.readAsync(byId: parent.eventId)
        let vm = SummaryViewModel(event: event, createdUntil: parent.parent.currentMoment)
        return Loadable<SummaryViewModel>(vm: vm)
    }
}
