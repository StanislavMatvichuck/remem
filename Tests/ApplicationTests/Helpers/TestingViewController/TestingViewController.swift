//
//  ViewControllerTesting.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 23.02.2023.
//

import Domain

protocol TestingViewController: AnyObject {
    associatedtype Controller
    var sut: Controller! { get set }
    var event: Event! { get set }

    func make()
}

extension TestingViewController {
    func clear() {
        sut = nil
        event = nil
        executeRunLoop()
    }
}
