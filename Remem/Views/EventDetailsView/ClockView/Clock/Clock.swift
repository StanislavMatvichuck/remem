//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

class Clock: UIView {
    // MARK: - Properties
    lazy var clockFace = ClockFace()

    lazy var iconDay = UIView(al: true)
    lazy var iconNight = UIView(al: true)

    lazy var topDigits: UILabel = makeLabel("12")
    lazy var rightDigits: UILabel = makeLabel("18")
    lazy var bottomDigits: UILabel = makeLabel("00")
    lazy var leftDigits: UILabel = makeLabel("06")

    // MARK: - Init
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private
extension Clock {
    private func setupLayout() {
        addLabels()
        addIcons()
        addAndConstrain(clockFace)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor),
        ])
    }

    private func addLabels() {
        addSubview(topDigits)
        addSubview(rightDigits)
        addSubview(bottomDigits)
        addSubview(leftDigits)

        let digitsDistanceFromCenter = -ClockSectionAnimatedLayer.length - 6.0

        NSLayoutConstraint.activate([
            topDigits.centerXAnchor.constraint(equalTo: centerXAnchor),
            rightDigits.centerYAnchor.constraint(equalTo: centerYAnchor),
            bottomDigits.centerXAnchor.constraint(equalTo: centerXAnchor),
            leftDigits.centerYAnchor.constraint(equalTo: centerYAnchor),

            topDigits.topAnchor.constraint(equalTo: topAnchor, constant: -digitsDistanceFromCenter),
            rightDigits.trailingAnchor.constraint(equalTo: trailingAnchor, constant: digitsDistanceFromCenter),
            bottomDigits.bottomAnchor.constraint(equalTo: bottomAnchor, constant: digitsDistanceFromCenter),
            leftDigits.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -digitsDistanceFromCenter),
        ])
    }

    private func addIcons() {
        let imageViewDay = makeIcon(name: "sun.max")
        let imageViewNight = makeIcon(name: "moon.stars")

        addSubview(imageViewDay)
        addSubview(imageViewNight)

        NSLayoutConstraint.activate([
            imageViewDay.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageViewNight.centerXAnchor.constraint(equalTo: centerXAnchor),

            imageViewDay.topAnchor.constraint(equalTo: topDigits.bottomAnchor),
            imageViewNight.bottomAnchor.constraint(equalTo: bottomDigits.topAnchor),
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = UIHelper.fontSmallBold
        label.textColor = UIHelper.clockSectionBackground
        return label
    }

    private func makeIcon(name: String) -> UIImageView {
        let image = UIImage(systemName: name)?
            .withTintColor(UIHelper.clockSectionBackground)
            .withRenderingMode(.alwaysOriginal)

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }
}
