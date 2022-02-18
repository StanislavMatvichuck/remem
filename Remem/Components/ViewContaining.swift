//
//  ViewContaining.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 18.02.2022.
//

import UIKit

/// Unifies creation of container views
protocol ViewContaining: UIView {
    func contain(views: UIView...)
}
