//
//  AnimatedProgressView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 09.05.2023.
//

import UIKit

final class AnimatedProgressView: UIView {
    static let width = CGFloat.screenW - 2 * CGFloat.buttonMargin

    private var progress: CGFloat = 0
    private var animatedProgressConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    /// Because this view animation depends on superview
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public
    func configure(_ vm: EventCellViewModel) {
        progress = vm.progress
        backgroundColor = vm.progressState.color
        move()
    }

    func prepareForReuse() { progress = 0 }

    func move() {
        let translation = (Self.width * progress).clamped(to: 0 ... Self.width)
        animatedProgressConstraint?.constant = translation
    }

    // MARK: - Private
    private func configureLayout() {
        guard let superview else { return }

        let animatedProgressConstraint = trailingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0)
        self.animatedProgressConstraint = animatedProgressConstraint

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Self.width),
            heightAnchor.constraint(equalToConstant: .buttonHeight),
            animatedProgressConstraint,
        ])
    }

    private func configureAppearance() {
        layer.cornerRadius = .buttonRadius
    }
}
