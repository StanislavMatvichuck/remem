//
//  ClockViewControllerHelpers.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.11.2022.
//

@testable import Application
import Domain
import XCTest

extension ClockViewController {
    func forceViewToLayoutInScreenSize() {
        view.bounds = UIScreen.main.bounds
        view.layoutIfNeeded()
    }
}
