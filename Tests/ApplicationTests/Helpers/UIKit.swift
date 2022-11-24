//
//  UIKit.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 03.11.2022.
//

import UIKit

//
// UIKit helpers
//

func putInViewHierarchy(_ vc: UIViewController) {
    let window = UIWindow()
    window.addSubview(vc.view)
}

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}

func tap(_ button: UIButton) {
    button.sendActions(for: .touchUpInside)
}

func tap(_ button: UIBarButtonItem) {
    _ = button.target?.perform(button.action, with: nil)
}

@discardableResult func shouldReturn(in textField: UITextField) -> Bool? {
    textField.delegate?.textFieldShouldReturn?(textField)
}
