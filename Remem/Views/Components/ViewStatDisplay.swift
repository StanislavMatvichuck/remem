//
//  StatDisplay.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 18.02.2022.
//

import UIKit

class ViewStatDisplay: UIView {
    static let defaultSpacing = UIHelper.spacing / 2
    static let defaultWidth = CGFloat.wScreen / 2.5

    // MARK: - Properties
    var title: UILabel?
    var image: UIImage?
    var imageView: UIImageView?
    var subtitle: UILabel

    // MARK: - Init
    init(title: String?, description: String) {
        self.subtitle = Self.makeSubtitle(description)
        self.title = Self.makeTitle(title ?? "")

        super.init(frame: .zero)
        commonInit(with: self.title!)
    }

    init(image: UIImage?, description: String) {
        self.subtitle = Self.makeSubtitle(description)
        self.image = image

        self.imageView = UIImageView(image: image)
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        imageView!.setContentHuggingPriority(.defaultHigh, for: .vertical)

        super.init(frame: .zero)
        commonInit(with: imageView!)
    }

    private func commonInit(with view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = .sm

        let flexibleSpace = UIView(al: true)

        let stack = UIStackView(al: true)
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = .xs

        stack.addArrangedSubview(view)
        stack.addArrangedSubview(subtitle)
        stack.addArrangedSubview(flexibleSpace)
        stack.setCustomSpacing(0, after: subtitle)

        addAndConstrain(stack, constant: Self.defaultSpacing)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Self.defaultWidth),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Public
extension ViewStatDisplay {
    func update(color: UIColor) {
        subtitle.textColor = color
    }

    func update(description: String) {
        subtitle.text = description
    }

    func updateImage(color: UIColor) {
        imageView?.image = image?.withTintColor(color)
    }
}

// MARK: - Private
extension ViewStatDisplay {
    private static func makeTitle(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.numberOfLines = 1
        label.font = UIHelper.fontBold
        label.textColor = UIHelper.itemFont
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }

    private static func makeSubtitle(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = UIHelper.font
        label.textColor = UIHelper.itemFont
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }
}
