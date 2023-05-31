//
//  CoreDataStackTesting.swift
//  DataLayer
//
//  Created by Stanislav Matvichuck on 19.02.2023.
//

import CoreData
import DataLayer
import Domain

enum TestingLaunchParameter: String {
    case empty, singleEvent
}

func scanLaunchArgumentsAndPrepareRepositoryIfNeeded(_ repository: CoreDataEventsRepository) {
    if let testingParameter = parseTestingLaunchParameters().first {
        prepare(repository, for: testingParameter)
    }
}

func parseTestingLaunchParameters() -> [TestingLaunchParameter] {
    let launchArguments = ProcessInfo.processInfo.arguments

    var recognizedParameters: [TestingLaunchParameter] = []

    for argument in launchArguments {
        if let parameter = TestingLaunchParameter(rawValue: argument) {
            recognizedParameters.append(parameter)
        }
    }

    return recognizedParameters
}

func prepare(_ repository: CoreDataEventsRepository, for testingCase: TestingLaunchParameter) {
    removeAllEventsFrom(repository: repository)

    switch testingCase {
    case .empty: return
    case .singleEvent:
        let event = Event(name: "Single event", dateCreated: DayIndex.referenceValue.date)
        repository.save(event)
    }
}

func removeAllEventsFrom(repository: CoreDataEventsRepository) {
    for event in repository.get() {
        repository.delete(event)
    }
}
