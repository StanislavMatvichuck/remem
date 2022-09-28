//
//  MulticastDelegate.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.08.2022.
//

import Foundation

class MulticastDelegate<ProtocolType> {
    private class DelegateWrapper {
        weak var delegate: AnyObject?

        init(_ delegate: AnyObject) {
            self.delegate = delegate
        }
    }

    private var delegateWrappers: [DelegateWrapper]

    private var delegates: [ProtocolType] {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }

        return delegateWrappers.map { $0.delegate! } as! [ProtocolType]
    }

    // MARK: - Object Lifecycle
    init(delegates: [ProtocolType] = []) {
        delegateWrappers = delegates.map { DelegateWrapper($0 as AnyObject) }
    }

    // MARK: - Delegate Management
    func addDelegate(_ delegate: ProtocolType) {
        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.append(wrapper)
    }

    func removeDelegate(_ delegate: ProtocolType) {
        guard let index = delegateWrappers.firstIndex(where:
            { $0.delegate === (delegate as AnyObject) })
        else { return }

        delegateWrappers.remove(at: index)
    }

    func call(_ closure: (ProtocolType) -> ()) {
        delegates.forEach { closure($0) }
    }
}
