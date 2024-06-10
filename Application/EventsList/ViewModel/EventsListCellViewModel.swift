//
//  EventsListCellViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 16.02.2024.
//

import Foundation

protocol EventsListCellViewModel {}

extension HintCellViewModel: EventsListCellViewModel {}
extension Loadable<EventCellViewModel>: EventsListCellViewModel {}
extension CreateEventCellViewModel: EventsListCellViewModel {}
