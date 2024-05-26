//
//  ApplicationService.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Foundation

struct ApplicationServiceEmptyArgument {}

protocol ApplicationService {
    associatedtype ServiceArgument
    mutating func serve(_: ServiceArgument)
}
