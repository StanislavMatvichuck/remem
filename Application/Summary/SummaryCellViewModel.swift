//
//  SummaryItemViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.02.2023.
//

import Foundation

struct SummaryCellViewModel {
    let title: String
    let value: String
    let titleTag: Int /// used by tests only
    let valueTag: Int /// used by tests only
    let belongsToUser: Bool
}
