//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

let ClockSectionMultiplier: CGFloat = 0.15
let ClockDigitsOffset: CGFloat = 8.0

class ClockView: UIView {
    // MARK: - Properties
    let clockFace: ClockFace

    let topDigits = makeLabel("12")
    let rightDigits = makeLabel("18")
    let bottomDigits = makeLabel("00")
    let leftDigits = makeLabel("06")
    private var updatedConstraints: [NSLayoutConstraint] = []

    // MARK: - Init
    init(viewModel: ClockViewModel) {
        self.clockFace = ClockFace(viewModel: viewModel)
        super.init(frame: .zero)
        backgroundColor = UIHelper.background
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        addSubview(clockFace)

        addLabels()
        addIcons()

        NSLayoutConstraint.activate([
            clockFace.widthAnchor.constraint(equalTo: widthAnchor),
            clockFace.heightAnchor.constraint(equalTo: heightAnchor),
            clockFace.centerXAnchor.constraint(equalTo: centerXAnchor),
            clockFace.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func addLabels() {
        addSubview(topDigits)
        addSubview(rightDigits)
        addSubview(bottomDigits)
        addSubview(leftDigits)

        let topConstraint = topDigits.topAnchor.constraint(equalTo: clockFace.topAnchor)
        let rightConstraint = rightDigits.trailingAnchor.constraint(equalTo: clockFace.trailingAnchor)
        let bottomConstraint = bottomDigits.bottomAnchor.constraint(equalTo: clockFace.bottomAnchor)
        let leftConstraint = leftDigits.leadingAnchor.constraint(equalTo: clockFace.leadingAnchor)

        NSLayoutConstraint.activate([
            topDigits.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor),
            rightDigits.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor),
            bottomDigits.centerXAnchor.constraint(equalTo: clockFace.centerXAnchor),
            leftDigits.centerYAnchor.constraint(equalTo: clockFace.centerYAnchor),

            topConstraint,
            rightConstraint,
            bottomConstraint,
            leftConstraint,
        ])

        updatedConstraints.append(topConstraint)
        updatedConstraints.append(rightConstraint)
        updatedConstraints.append(bottomConstraint)
        updatedConstraints.append(leftConstraint)
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
        label.textColor = UIColor.secondary
        return label
    }

    private func makeIcon(name: String) -> UIImageView {
        let image = UIImage(systemName: name)?
            .withTintColor(UIColor.secondary)
            .withRenderingMode(.alwaysOriginal)

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updatedConstraints.forEach {
            guard $0.constant == 0 else { return }

            $0.constant = bounds.width * ClockSectionMultiplier + ClockDigitsOffset

            if $0.firstAnchor.isEqual(rightDigits.trailingAnchor) ||
                $0.firstAnchor.isEqual(bottomDigits.bottomAnchor)
            {
                $0.constant *= -1
            }
        }
    }
}
