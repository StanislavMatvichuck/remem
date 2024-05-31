//
//  LoadableViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.05.2024.
//

import UIKit

struct LoadableViewModelWrapper<LoadingArguments, ViewModel> {
    let loadingArguments: LoadingArguments?
    let loading: Bool
    let vm: ViewModel?

    init(
        loadingArguments: LoadingArguments? = nil,
        loading: Bool = true,
        vm: ViewModel? = nil
    ) {
        self.loadingArguments = loadingArguments
        self.loading = loading
        self.vm = vm
    }
}
