//
//  ExtensionUIView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

extension UIView {
    func addAndConstrain(_ view: UIView, constant: CGFloat = 0) {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            view.topAnchor.constraint(equalTo: topAnchor, constant: constant),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * constant),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * constant),
        ])
    }

    /// Initializer made to shorten programmatic `UIView` creation
    /// - Parameter al: AutoLayout usage flag
    convenience init(al: Bool) {
        self.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !al
    }
}
