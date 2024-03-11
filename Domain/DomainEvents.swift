//
//  Events.swift
//  Domain
//
//  Created by Stanislav Matvichuck on 10.03.2024.
//

import Foundation

enum DomainEvents: String {
    case eventCreated, eventVisited
}

enum UserInfoCodingKeys: String { case event }

public struct EventCreated: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.eventCreated.rawValue)

    public let event: Event

    public init(userInfo: DomainEventsPublisher.UserInfo) {
        self.event = userInfo[UserInfoCodingKeys.event] as! Event
    }

    public init(event: Event) { self.event = event }

    public func userInfo() -> DomainEventsPublisher.UserInfo { [UserInfoCodingKeys.event: event] }
}

public struct EventRemoved {}
public struct EventVisited: DomainEventsPublisher.DomainEvent {
    public static var eventName = Notification.Name(DomainEvents.eventVisited.rawValue)

    public let event: Event

    public init(userInfo: DomainEventsPublisher.UserInfo) {
        self.event = userInfo[UserInfoCodingKeys.event] as! Event
    }

    public init(event: Event) { self.event = event }

    public func userInfo() -> DomainEventsPublisher.UserInfo { [UserInfoCodingKeys.event: event] }
}

public struct HappeningCreated {}
public struct HappeningRemoved {}
public struct GoalCreated {}
public struct GoalRemoved {}
public struct GoalValueUpdated {}
public struct GoalAchieved {}
public struct EventsSorterChanged {}
