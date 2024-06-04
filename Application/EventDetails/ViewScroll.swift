//
//  ViewScroll.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 18.02.2022.
//

import UIKit

class ViewScroll: UIScrollView {
    // MARK: - Properties
    var viewContent: UIStackView
    // MARK: - Init
    init(_ axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0) {
        viewContent = UIStackView(frame: .zero)
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        viewContent.axis = axis
        viewContent.spacing = spacing

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        setupLayout(axis: axis)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    func setupLayout(axis: NSLayoutConstraint.Axis) {
        addSubview(viewContent)

        NSLayoutConstraint.activate([
            viewContent.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            viewContent.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            viewContent.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            viewContent.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),

            axis == .vertical ?
                viewContent.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor) :
                viewContent.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor),
        ])
    }

    func contain(views: UIView...) {
        for view in views {
            viewContent.addArrangedSubview(view)
        }
    }
}
