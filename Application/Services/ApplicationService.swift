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
    func serve(_: ServiceArgument)
}
