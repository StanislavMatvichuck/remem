//
//  EntityMapper.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 02.08.2022.
//

import Foundation

// MARK: - EntityMapper
public class EntityMapper<DomainModel, Entity> {
    public func convert(_ entity: Entity) -> DomainModel? {
        fatalError("convert(_ entity: Entity: must be overrided")
    }

    public func update(_ entity: Entity, by model: DomainModel) {
        fatalError("supdate(_ entity: Entity: must be overrided")
    }

    public func entityAccessorKey(_ entity: Entity) -> String {
        fatalError("entityAccessorKey must be overrided")
    }

    public func entityAccessorKey(_ object: DomainModel) -> String {
        fatalError("entityAccessorKey must be overrided")
    }
}
