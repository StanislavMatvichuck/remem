//
//  FileSaving.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import Foundation

protocol FileSaving {
    func save(_: Data, to: URL)
}

struct DefaultLocalFileSaver: FileSaving {
    func save(_ data: Data, to: URL) {
        do {
            try data.write(to: to)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
