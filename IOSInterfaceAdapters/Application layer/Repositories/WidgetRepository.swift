//
//  WidgetRepository.swift
//  IOSInterfaceAdapters
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import RememDomain

public protocol WidgetRepositoryInterface {
    func update(eventsList: [Event])
    func read() -> Codable
}
