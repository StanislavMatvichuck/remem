//
//  WeakRef.swift
//  Application
//
//  Created by Stanislav Matvichuck on 05.03.2023.
//

import Foundation

final class WeakRef<T: AnyObject> {
    weak var weakRef: T?
    init(_ weakRef: T?) { self.weakRef = weakRef }
}

extension WeakRef: Updating where T: Updating {
    func update() { weakRef?.update() }
}

extension WeakRef: DayDetailsDataProviding where T: DayDetailsDataProviding {
    var viewModel: DayDetailsViewModel? { weakRef?.viewModel }
}

extension WeakRef: SummaryDataProviding where T: SummaryDataProviding {
    var viewModel: SummaryViewModel? { weakRef?.viewModel }
}
