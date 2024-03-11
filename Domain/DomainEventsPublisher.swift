//
//  EventsPublisher.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Foundation

public class DomainEventsPublisher {
    public static var shared = DomainEventsPublisher()

    private let notificationCenter = NotificationCenter.default
    
    private init() {}
    
    // MARK: - Protocol for events creation
    
    public typealias UserInfo = [AnyHashable: Any]

    public protocol DomainEvent {
        static var eventName: Notification.Name { get }
        
        init(userInfo: UserInfo)
        func userInfo() -> UserInfo
    }
    
    // MARK: - Event Publishing and Subscribing
    
    public func publish<T: DomainEvent>(_ event: T) {
        event.post(notificationCenter: notificationCenter)
    }
    
    public func subscribe<T: DomainEvent>(
        _ eventKind: T.Type,
        queue: OperationQueue = .main,
        usingBlock block: @escaping (T) -> Void
    ) -> DomainEventSubscription {
        let observer = notificationCenter.addObserver(
            forName: T.eventName,
            object: nil,
            queue: queue
        ) { notification in
            let userInfo = notification.userInfo!
            let event = T(userInfo: userInfo)
            block(event)
        }
        
        return DomainEventSubscription(observer: observer, eventPublisher: self)
    }
    
    public func unsubscribe(_ subscriber: AnyObject) {
        notificationCenter.removeObserver(subscriber)
    }
    
    // MARK: - Subscription
    
    public class DomainEventSubscription {
        let observer: NSObjectProtocol
        let eventPublisher: DomainEventsPublisher
        
        public init(observer: NSObjectProtocol, eventPublisher: DomainEventsPublisher) {
            self.observer = observer
            self.eventPublisher = eventPublisher
        }
        
        deinit { eventPublisher.unsubscribe(observer) }
    }
}

extension DomainEventsPublisher.DomainEvent {
    public func notification() -> Notification { Notification(
        name: type(of: self).eventName,
        object: nil,
        userInfo: userInfo()
    ) }

    func post(notificationCenter: NotificationCenter) {
        notificationCenter.post(notification())
    }
}
