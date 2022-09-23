//
//  WidgetFileWriting.swift
//  IosUseCases
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import Domain
import Foundation

public protocol WidgetFileWriting {
    func update(eventsList: [Event])
}
