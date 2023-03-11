//
//  MulticastDelegate.swift
//  Application
//
//  Created by Stanislav Matvichuck on 11.03.2023.
//

import Foundation

class MulticastDelegate<T> {
    private var delegateWrappers: [DelegateWrapper]
    private class DelegateWrapper {
        weak var delegate: AnyObject?
        init(_ delegate: AnyObject) { self.delegate = delegate }
    }

    var delegates: [T] {
        removeNullifiedWrappers()
        return delegateWrappers.map { $0.delegate! } as! [T]
    }

    init(delegates: [T] = []) {
        delegateWrappers = delegates.map { DelegateWrapper($0 as AnyObject) }
    }

    func addDelegate(_ delegate: T) {
        removeNullifiedWrappers()
        removeCopies(delegate)

        let wrapper = DelegateWrapper(delegate as AnyObject)
        delegateWrappers.insert(wrapper, at: 0)
    }

    func removeDelegate(_ delegate: T) {
        guard let index = delegateWrappers.firstIndex(where: {
            $0.delegate === (delegate as AnyObject)
        }) else {
            return
        }
        delegateWrappers.remove(at: index)
    }

    func call(_ closure: (T) -> ()) {
        delegates.forEach { closure($0) }
    }

    private func removeCopies(_ delegate: T) {
        for wrapper in delegateWrappers {
            if let existingDelegate = wrapper.delegate,
               existingDelegate === (delegate as AnyObject)
            {
                removeDelegate(delegate)
            }
        }
    }

    private func removeNullifiedWrappers() {
        delegateWrappers = delegateWrappers.filter { $0.delegate != nil }
    }
}
