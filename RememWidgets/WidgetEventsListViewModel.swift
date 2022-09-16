//
//  TimelineEntry.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.09.2022.
//

import IOSInterfaceAdapters
import RememDomain
import WidgetKit

struct WidgetEventsListViewModel: TimelineEntry {
    let date: Date
    let listViewModel: EventsListViewModelState

    init(date: Date = Date(), listViewModel: EventsListViewModel) {
        self.listViewModel = listViewModel
        self.date = date
    }

    func eventViewModel(atIndex: Int) -> EventCellViewModelingState {
        let event = listViewModel.event(at: atIndex)
        let viewModel = EventCellViewModel(event: event!, editUseCase: EventEditUseCase(repository: EventsRepositoryMock()))
        return viewModel
    }
}
