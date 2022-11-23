//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

class ClockView: UIView {
    // MARK: - Properties
    let clockFace: ClockFace

    let topDigits = makeLabel("12")
    let rightDigits = makeLabel("18")
    let bottomDigits = makeLabel("00")
    let leftDigits = makeLabel("06")

    // MARK: - Init
    init(viewModel: ClockViewModel) {
        self.clockFace = ClockFace(viewModel: viewModel)
        super.init(frame: .zero)
        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        addLabels()
        addIcons()
        addSubview(clockFace)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor),

            clockFace.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
            clockFace.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),

            clockFace.topAnchor.constraint(equalTo: topAnchor),
            clockFace.bottomAnchor.constraint(equalTo: bottomAnchor),
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

    private static func makeLabel(_ text: String) -> UILabel {
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
