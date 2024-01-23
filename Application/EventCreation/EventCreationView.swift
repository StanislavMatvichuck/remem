//
//  EventCreationView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

import Foundation
import UIKit

final class EventCreationView: UIView {
    init() {
        super.init(frame: .zero)
        configureLayout()
        configureAppearance()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Private
    private func configureLayout() {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false

        addAndConstrain(blurView)
    }

    private func configureAppearance() {}
}
