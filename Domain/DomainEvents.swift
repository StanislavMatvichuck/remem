//
//  Events.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Foundation

enum DomainEvents: String {
    case eventCreated,
         eventVisited,
         eventRemoved,

         eventsListOrderingSet,
         happeningCreated,
         happeningRemoved
}

enum UserInfoCodingKeys: String { case event, eventsListOrdering, eventId }

public struct EventCreated: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.eventCreated.rawValue)

    public let event: Event

    public init(userInfo: DomainEventsPublisher.UserInfo) {
        self.event = userInfo[UserInfoCodingKeys.event] as! Event
    }

    public init(event: Event) { self.event = event }

    public func userInfo() -> DomainEventsPublisher.UserInfo { [UserInfoCodingKeys.event: event] }
}

public struct EventRemoved: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.eventRemoved.rawValue)

    let eventId: String

    public init(userInfo: DomainEventsPublisher.UserInfo) {
        self.eventId = userInfo[UserInfoCodingKeys.eventId] as! String
    }

    public init(eventId: String) { self.eventId = eventId }

    public func userInfo() -> DomainEventsPublisher.UserInfo { [UserInfoCodingKeys.eventId: eventId] }
}

public struct EventVisited: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.eventVisited.rawValue)

    public let event: Event

    public init(userInfo: DomainEventsPublisher.UserInfo) {
        self.event = userInfo[UserInfoCodingKeys.event] as! Event
    }

    public init(event: Event) { self.event = event }

    public func userInfo() -> DomainEventsPublisher.UserInfo { [UserInfoCodingKeys.event: event] }
}

public struct HappeningCreated: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.happeningCreated.rawValue)

    public let eventId: String

    public init(userInfo: DomainEventsPublisher.UserInfo) {
        self.eventId = userInfo[UserInfoCodingKeys.eventId] as! String
    }

    public init(eventId: String) { self.eventId = eventId }

    public func userInfo() -> DomainEventsPublisher.UserInfo { [UserInfoCodingKeys.eventId: eventId] }
}

public struct HappeningRemoved: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.happeningRemoved.rawValue)

    public let eventId: String

    public init(userInfo: DomainEventsPublisher.UserInfo) {
        self.eventId = userInfo[UserInfoCodingKeys.eventId] as! String
    }

    public init(eventId: String) { self.eventId = eventId }

    public func userInfo() -> DomainEventsPublisher.UserInfo { [UserInfoCodingKeys.eventId: eventId] }
}

public struct GoalCreated {}
public struct GoalRemoved {}
public struct GoalValueUpdated {}
public struct GoalAchieved {}
public struct EventsListOrderingSet: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.eventsListOrderingSet.rawValue)

    public init(userInfo: DomainEventsPublisher.UserInfo) {}

    public init() {}

    public func userInfo() -> DomainEventsPublisher.UserInfo { [:] }
}
