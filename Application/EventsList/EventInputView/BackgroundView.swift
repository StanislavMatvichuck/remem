//
//  BackgroundView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 16.05.2023.
//

import UIKit

final class BackgroundView: UIView {
    let hint: UILabel = {
        let label = UILabel(al: true)
        label.text = String(localizationId: "eventsList.new")
        label.textAlignment = .center
        label.font = .fontBold
        label.textColor = UIColor.secondary
        label.numberOfLines = 0
        return label
    }()

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
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

        addSubview(hint)
        NSLayoutConstraint.activate([
            hint.widthAnchor.constraint(equalTo: readableContentGuide.widthAnchor),
            hint.centerXAnchor.constraint(equalTo: readableContentGuide.centerXAnchor),
            hint.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .buttonMargin),
        ])
    }

    private func configureAppearance() {
        isHidden = true
        backgroundColor = .clear
    }
}
