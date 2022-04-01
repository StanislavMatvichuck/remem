//
//  UISwiperManager.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 31.03.2022.
//

import UIKit

protocol UISwipingSelectorInterface: UIControl, UIScrollViewDelegate {
    func listen(scrollView: UIScrollView)
    func hideSettings()
    func showSettings()
}

class UISwipingSelector: UIControl, UISwipingSelectorInterface {
    //

    // MARK: - Related types

    //

    enum SelectableOption {
        case addEntry
        case settings
    }

    //

    // MARK: - Private properties

    //

    fileprivate let viewRoot = UISwipingSelectorView()

    fileprivate var settingsLeft: CGFloat { viewRoot.viewSettings.frame.minX }
    fileprivate var settingsRight: CGFloat { viewRoot.viewSettings.frame.maxX }
    fileprivate var addLeft: CGFloat { viewRoot.viewAddEntry.frame.minX }

    //

    // MARK: - Public properties

    //

    var value: SelectableOption?

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        addAndConstrain(viewRoot)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Behaviour

    //

    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let newContentOffset = -3 * scrollView.contentOffset.y

        viewRoot.pointerHorizontalConstraint.constant = newContentOffset.clamped(to: 0 ... (UIScreen.main.bounds.width - .delta1))

        if
            !viewRoot.viewSettings.isHidden,
            newContentOffset >= settingsLeft + .r2,
            newContentOffset <= settingsRight
        {
            animateSelectedState(to: true, for: viewRoot.viewSettings)
        } else {
            animateSelectedState(to: false, for: viewRoot.viewSettings)
        }

        if newContentOffset >= addLeft + .r2 {
            animateSelectedState(to: true, for: viewRoot.viewAddEntry)
        } else {
            animateSelectedState(to: false, for: viewRoot.viewAddEntry)
        }
    }

    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if
            let isCreatePointSelected = isViewSelected[viewRoot.viewAddEntry],
            isCreatePointSelected
        {
            value = .addEntry
            sendActions(for: .primaryActionTriggered)
            return
        }

        if
            !viewRoot.viewSettings.isHidden,
            let isSettingsSelected = isViewSelected[viewRoot.viewSettings],
            isSettingsSelected
        {
            value = .settings
            sendActions(for: .primaryActionTriggered)
            return
        }
    }

    func listen(scrollView: UIScrollView) {
        scrollView.delegate = self
    }

    func hideSettings() {
        viewRoot.viewSettings.isHidden = true
    }

    func showSettings() {
        viewRoot.viewSettings.isHidden = false
    }

    //

    // MARK: - Animations

    //

    lazy var isViewSelected: [UIView: Bool] = [
        viewRoot.viewSettings: false,
        viewRoot.viewAddEntry: false,
    ]

    func animateSelectedState(to isSelected: Bool, for view: UIView) {
        guard isSelected != isViewSelected[view] else { return }

        let animation = createSelectedAnimation(isSelected: isSelected)

        view.layer.backgroundColor = isSelected ?
            UIColor.systemBlue.cgColor :
            UIColor.secondarySystemBackground.cgColor

        view.layer.add(animation, forKey: nil)

        isViewSelected[view] = isSelected

        if isSelected {
            UIDevice.vibrate(.soft)
        }
    }

    private func createSelectedAnimation(isSelected: Bool) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "backgroundColor")

        animation.fromValue = isSelected ? UIColor.secondarySystemBackground : UIColor.systemBlue
        animation.toValue = isSelected ? UIColor.systemBlue : UIColor.secondarySystemBackground

        animation.duration = 0.2

        animation.timingFunction = CAMediaTimingFunction(name: .linear)

        return animation
    }
}

//

// MARK: - UISwipingSelectorView

//

private class UISwipingSelectorView: UIView {
    fileprivate lazy var viewAddEntry = makeButton(text: "Add")
    fileprivate lazy var viewSettings = makeButton(text: "Settings")

    fileprivate let viewPointer: UIView = {
        let view = UIView(al: true)

        view.backgroundColor = .systemBlue
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

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(viewPointer)
        addSubview(viewSettings)
        addSubview(viewAddEntry)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: .wScreen),
            heightAnchor.constraint(equalToConstant: .r2),

            viewPointer.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewSettings.centerYAnchor.constraint(equalTo: centerYAnchor),
            viewAddEntry.centerYAnchor.constraint(equalTo: centerYAnchor),

            viewSettings.heightAnchor.constraint(equalTo: heightAnchor),
            viewAddEntry.heightAnchor.constraint(equalTo: heightAnchor),

            pointerHorizontalConstraint,
            viewAddEntry.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.delta1),
            viewSettings.trailingAnchor.constraint(equalTo: viewAddEntry.leadingAnchor, constant: -.delta1),
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Internal behaviour

    //

    fileprivate func makeButton(text: String) -> UIView {
        let view = UIView(al: true)
        view.backgroundColor = .secondarySystemBackground
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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        viewPointer.layer.backgroundColor = UIColor.secondarySystemBackground.cgColor
    }
}
