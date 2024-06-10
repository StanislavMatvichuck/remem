//
//  LoadableViewModelHandler.swift
//  Application
//
//  Created by Stanislav Matvichuck on 07.06.2024.
//

import UIKit

protocol LoadableViewModel {
    associatedtype ViewModel
    var vm: ViewModel? { get }
}

protocol UsingLoadableViewModel: UIView {
    associatedtype ViewModel: LoadableViewModel
    var viewModel: ViewModel? { get set }
}

protocol LoadedViewModelFactoring {
    associatedtype ViewModel: LoadableViewModel
    func makeLoaded() async throws -> ViewModel
}

protocol LoadingViewModelFactoring {
    func makeLoading() -> any LoadableViewModel
}

struct Loadable<ViewModel>: LoadableViewModel {
    let loading: Bool
    let vm: ViewModel?

    init() {
        self.loading = true
        self.vm = nil
    }

    init(vm: ViewModel) {
        self.loading = false
        self.vm = vm
    }
}

protocol LoadableEventCellViewModelFactoring: LoadedViewModelFactoring where ViewModel == Loadable<EventCellViewModel> {}
protocol LoadableWeekViewModelFactoring: LoadedViewModelFactoring where ViewModel == Loadable<WeekViewModel> {}
protocol LoadableSummaryViewModelFactoring: LoadedViewModelFactoring where ViewModel == Loadable<SummaryViewModel> {}
protocol LoadableDayOfWeekViewModelFactoring: LoadedViewModelFactoring where ViewModel == Loadable<DayOfWeekViewModel> {}
protocol LoadableHourDistributionViewModelFactoring: LoadedViewModelFactoring where ViewModel == Loadable<HourDistributionViewModel> {}

protocol LoadableViewModelHandling {
    func load<
        View: UsingLoadableViewModel,
        Factory: LoadedViewModelFactoring
    >(
        for: View,
        factory: Factory
    ) where View.ViewModel == Factory.ViewModel

    func cancel(for: any UsingLoadableViewModel)
}

final class LoadableViewModelHandler: LoadableViewModelHandling {
    private var loadingTasks: [UIView: Task<Void, Never>] = [:]

    func load<
        View: UsingLoadableViewModel,
        Factory: LoadedViewModelFactoring
    >(
        for view: View,
        factory: Factory
    ) where View.ViewModel == Factory.ViewModel {
        // TODO: add loading vm immediately
        let task = Task(priority: .userInitiated) { do {
            let vm = try await factory.makeLoaded()
            await MainActor.run { view.viewModel = vm }
        } catch {} }

        loadingTasks.updateValue(task, forKey: view)
    }

    func cancel(for view: any UsingLoadableViewModel) {
        let cancelledTask = loadingTasks.removeValue(forKey: view)
        cancelledTask?.cancel()
    }
}
