//
//  UISwiperManager.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 31.03.2022.
//

import UIKit

protocol UISwipingSelectorInterface: UIControl {
    func handleScrollView(contentOffset: CGPoint)
    func handleScrollViewDraggingEnd()

    func hideSettings()
    func showSettings()
}

class UISwipingSelector: UIControl, UISwipingSelectorInterface {
    enum SelectableOption {
        case addEntry
        case settings
    }

    // MARK: I18n
    static let settings = NSLocalizedString(
        "button.settings", comment: "button Settings")
    static let addEntry = NSLocalizedString(
        "button.add.entry", comment: "button Add entry")

    // MARK: - Properties
    private var settingsLeft: CGFloat { viewSettings.frame.minX + .r2 }
    private var settingsRight: CGFloat { viewSettings.frame.maxX }
    private var addLeft: CGFloat { viewAddEntry.frame.minX }

    var value: SelectableOption?

    // UIView
    private lazy var viewAddEntry = makeButton(text: UISwipingSelector.addEntry)
    private lazy var viewSettings = makeButton(text: UISwipingSelector.settings)

    fileprivate let defaultButtonBackground = UIColor.clear
    fileprivate let selectedButtonBackground = UIColor.systemBlue.withAlphaComponent(0.75)

    fileprivate lazy var viewPointer: UIView = {
        let view = UIView(al: true)

        view.backgroundColor = selectedButtonBackground
        view.layer.cornerRadius = .r2 / 2

        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .r2),
            view.heightAnchor.constraint(equalToConstant: .r2),
        ])

        return view
    }()

    lazy var pointerHorizontalConstraint: NSLayoutConstraint = {
        let constraint = viewPointer.trailingAnchor.constraint(equalTo: leadingAnchor)

        return constraint
    }()

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(viewPointer)
        addSubview(viewSettings)
        addSubview(viewAddEntry)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: .r2),

            viewPointer.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewSettings.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewAddEntry.centerYAnchor.constraint(equalTo: centerYAnchor),

            viewSettings.heightAnchor.constraint(equalTo: heightAnchor),
            viewAddEntry.heightAnchor.constraint(equalTo: heightAnchor),

            pointerHorizontalConstraint,
            viewAddEntry.trailingAnchor.constraint(equalTo: trailingAnchor),
            viewSettings.trailingAnchor.constraint(equalTo: viewAddEntry.leadingAnchor, constant: -.sm),
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    lazy var isViewSelected: [UIView: Bool] = [
        viewSettings: false,
        viewAddEntry: false,
    ]
}

// MARK: - Public
extension UISwipingSelector {
    func handleScrollView(contentOffset: CGPoint) {
        let newContentOffset = -3 * contentOffset.y

        pointerHorizontalConstraint.constant = newContentOffset.clamped(to: 0 ... bounds.width)

        if
            !viewSettings.isHidden,
            newContentOffset >= settingsLeft,
            newContentOffset <= settingsRight
        {
            animateSelectedState(to: true, for: viewSettings)
        } else {
            animateSelectedState(to: false, for: viewSettings)
        }

        if newContentOffset >= addLeft + .r2 {
            animateSelectedState(to: true, for: viewAddEntry)
        } else {
            animateSelectedState(to: false, for: viewAddEntry)
        }
    }

    func handleScrollViewDraggingEnd() {
        if
            let isCreatePointSelected = isViewSelected[viewAddEntry],
            isCreatePointSelected
        {
            value = .addEntry
            sendActions(for: .primaryActionTriggered)
            return
        }

        if
            !viewSettings.isHidden,
            let isSettingsSelected = isViewSelected[viewSettings],
            isSettingsSelected
        {
            value = .settings
            sendActions(for: .primaryActionTriggered)
            return
        }
    }

    func hideSettings() {
        viewSettings.isHidden = true
    }

    func showSettings() {
        viewSettings.isHidden = false
    }
}

// MARK: - Private
extension UISwipingSelector {
    private func animateSelectedState(to isSelected: Bool, for view: UIView) {
        guard isSelected != isViewSelected[view] else { return }

        let animation = createSelectedAnimation(isSelected: isSelected)

        view.layer.backgroundColor = isSelected ?
            selectedButtonBackground.cgColor :
            defaultButtonBackground.cgColor

        view.layer.add(animation, forKey: nil)

        isViewSelected[view] = isSelected

        if isSelected {
            UIDevice.vibrate(.soft)
        }
    }

    private func createSelectedAnimation(isSelected: Bool) -> CABasicAnimation {
        let defaultColor = defaultButtonBackground
        let selectedColor = selectedButtonBackground

        let animation = CABasicAnimation(keyPath: "backgroundColor")

        animation.fromValue = isSelected ? defaultColor : selectedColor
        animation.toValue = isSelected ? selectedColor : defaultColor

        animation.duration = 0.2

        animation.timingFunction = CAMediaTimingFunction(name: .linear)

        return animation
    }

    private func makeButton(text: String) -> UIView {
        let view = UIView(al: true)
        view.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.5)
        view.layer.cornerRadius = .r2 / 2

        let label = UILabel(al: true)
        label.font = .systemFont(ofSize: .font1)
        label.textAlignment = .center
        label.textColor = .label
        label.text = text

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            view.widthAnchor.constraint(equalTo: label.widthAnchor, constant: .lg),

        ])

        return view
    }
}

// MARK: - Dark mode
extension UISwipingSelector {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateBackgroundColors()
    }

    private func updateBackgroundColors() {
        viewPointer.backgroundColor = selectedButtonBackground
        viewSettings.backgroundColor = defaultButtonBackground
        viewAddEntry.backgroundColor = defaultButtonBackground

        if let labelSettings = viewSettings.subviews[0] as? UILabel {
            labelSettings.textColor = .label
        }

        if let labelAddEntry = viewSettings.subviews[0] as? UILabel {
            labelAddEntry.textColor = .label
        }
    }
}
