//
//  ViewControllersUpdater.swift
//  Application
//
//  Created by Stanislav Matvichuck on 11.03.2023.
//

import Foundation

final class ViewControllersUpdater: MulticastDelegate<Updating>, Updating {
    func update() { call { $0.update() } }
}
