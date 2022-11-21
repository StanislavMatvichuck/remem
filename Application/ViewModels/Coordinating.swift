//
//  Coordinating.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 05.09.2022.
//

import Foundation
import Domain

public protocol Coordinating: AnyObject {
    func showDetails(event: Event)
    func showDay(event: Event, date: Date)
    func showGoalsInput(event: Event)
    func dismiss()
}
