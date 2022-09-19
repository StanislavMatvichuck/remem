//
//  WidgetFileReader.swift
//  RememDataLayer
//
//  Created by Stanislav Matvichuck on 19.09.2022.
//

import IOSInterfaceAdapters
import RememDomain

public class FileWidgetRepository: WidgetRepositoryInterface {
    public func update(eventsList: [Event]) {}

    public func read() -> Codable {
        return WidgetEventViewModel(name: "Default", amount: "vm", hasGoal: false, goalReached: false)
    }

    public init() {}
}
