//
//  EventCreationViewModelTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 22.01.2024.
//

@testable import Application
import Foundation
import XCTest

final class EventCreationViewModelTests: XCTestCase {
    func test_init() { _ = EventCreationViewModel() }
    func test_init_canReceiveSubmitHandler() {
        _ = EventCreationViewModel(submitHandler: { _ in })
    }
    
    func test_emoji() {
        let sut = EventCreationViewModel()
        
        XCTAssertLessThan(3, sut.emoji.count)
    }
    
    func test_hint() {
        XCTAssertEqual(EventCreationViewModel.hint, "Short name or emoji")
    }
    
    func test_createdEventName_emptyByDefault() {
        let sut = EventCreationViewModel()
        
        XCTAssertEqual(sut.createdEventName.count, 0)
    }
    
    func test_submit_createdEventNameEmpty_doesNotCallSubmitHandler() {
        var submitHandlerCalled = false
        let submitHandler: EventCreationViewModel.SubmitHandler = { _ in submitHandlerCalled = true }
        let sut = EventCreationViewModel(submitHandler: submitHandler)
        
        sut.submit()
        
        XCTAssertFalse(submitHandlerCalled)
    }
    
    func test_submit_createdEventNameIsNotEmpty_submitHandlerIsCalledWithCreatedEventName() {
        var submitHandlerCalled = false
        var submitHandlerNameArgument = ""
        
        let submitHandler: EventCreationViewModel.SubmitHandler = { createdEventName in
            submitHandlerCalled = true
            submitHandlerNameArgument = createdEventName
        }
        
        var sut = EventCreationViewModel(submitHandler: submitHandler)
        
        sut.createdEventName = "Some"
        sut.submit()
        
        XCTAssertTrue(submitHandlerCalled)
        XCTAssertEqual(submitHandlerNameArgument, "Some")
    }
    
    func test_handleEmoji_addsItToCreatedEventName() {
        var sut = EventCreationViewModel()
        
        XCTAssertEqual(sut.createdEventName, "")
        
        sut.handle(emoji: 0)
        
        XCTAssertEqual(sut.createdEventName, sut.emoji.first)
    }
}
