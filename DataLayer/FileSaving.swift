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

public struct DefaultLocalFileSaver: FileSaving {
    public func save(_ data: Data, to: URL) {
        do {
            try data.write(to: to)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    public init() {}
}
