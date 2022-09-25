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

public class WidgetFileWriter: WidgetFileWriting {
    public func update(eventsList: [Event]) {
//        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.com.rderik.sharefriends")
//               let archiveURL = documentsDirectory?.appendingPathComponent("rderikFriends.json")
//                let encoder = JSONEncoder()
//                if let dataToSave = try? encoder.encode(friends) {
//                    do {
//                        try dataToSave.write(to: archiveURL!)
//                    } catch {
//                        // TODO: ("Error: Can't save Counters")
//                        return;
//                    }
//                }
    }

    public init() {}
}
