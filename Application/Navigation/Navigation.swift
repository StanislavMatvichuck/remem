//
//  Navigation.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import UIKit

protocol ControllerFactoring {
    func make() -> UIViewController
}

enum Navigation {
    case eventsList(factory: ControllerFactoring)
    case eventDetails(factory: ControllerFactoring)
    case dayDetails(factory: ControllerFactoring)
    case pdf(factory: ControllerFactoring)

    var controller: UIViewController {
        switch self {
        case .eventsList(let factory): return factory.make()
        case .eventDetails(let factory): return factory.make()
        case .dayDetails(let factory): return factory.make()
        case .pdf(let factory): return factory.make()
        }
    }
}
