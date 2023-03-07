//
//  WeakRef.swift
//  Application
//
//  Created by Stanislav Matvichuck on 05.03.2023.
//

import Foundation

final class WeakRef<T: AnyObject> {
    weak var weakRef: T?

    init(_ weakRef: T?) {
        self.weakRef = weakRef
    }
}

extension WeakRef: EventItemViewModelRenameHandling where T: EventItemViewModelRenameHandling {
    func renameTapped(_ item: EventItemViewModel) {
        weakRef?.renameTapped(item)
    }
}

extension WeakRef: FooterItemViewModelTapHandling where T: FooterItemViewModelTapHandling {
    func tapped(_ vm: FooterItemViewModel) {
        weakRef?.tapped(vm)
    }
}
