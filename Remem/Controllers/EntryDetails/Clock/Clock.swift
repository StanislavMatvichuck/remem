//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

class Clock: UIView {
    enum ClockVariant {
        case day
        case night
    }

    // MARK: - Properties
    private let variant: ClockVariant
    let clockFace = ClockFace()

    private lazy var iconContainer = UIView(al: true)
    private lazy var topDigits: UILabel = makeLabel(variant == .day ? "12" : "00")
    private lazy var rightDigits: UILabel = makeLabel(variant == .day ? "15" : "03")
    private lazy var bottomDigits: UILabel = makeLabel(variant == .day ? "18" : "06")
    private lazy var leftDigits: UILabel = makeLabel(variant == .day ? "21" : "09")

    // MARK: - Init
    init(for variant: ClockVariant) {
        self.variant = variant
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addLabels()
        addIcon()
        addClock()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func layoutSubviews() {
        constrainLabelsInsideClockFace()
        super.layoutSubviews()

        iconContainer.layer.cornerRadius = iconContainer.layer.frame.width / 2
    }
}

// MARK: - Private
extension Clock {
    private func addClock() {
        clockFace.translatesAutoresizingMaskIntoConstraints = false
        addAndConstrain(clockFace)
    }

    private func addLabels() {
        addSubview(topDigits)
        addSubview(rightDigits)
        addSubview(bottomDigits)
        addSubview(leftDigits)

        NSLayoutConstraint.activate([
            topDigits.centerXAnchor.constraint(equalTo: centerXAnchor),
            rightDigits.centerYAnchor.constraint(equalTo: centerYAnchor),
            bottomDigits.centerXAnchor.constraint(equalTo: centerXAnchor),
            leftDigits.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = .systemFont(ofSize: .font1, weight: .bold)
        label.textColor = .secondarySystemBackground
        return label
    }

    private func addIcon() {
        let imageView = UIImageView(image: makeIcon())
        imageView.translatesAutoresizingMaskIntoConstraints = false

        iconContainer.backgroundColor = .systemBackground
        iconContainer.addAndConstrain(imageView, constant: 5)
        addSubview(iconContainer)

        NSLayoutConstraint.activate([
            iconContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40.0),

            iconContainer.widthAnchor.constraint(equalToConstant: 40.0),
            iconContainer.heightAnchor.constraint(equalToConstant: 40.0),
        ])
    }

    private func makeIcon() -> UIImage {
        let image = UIImage(systemName: variant == .day ? "sun.max" : "moon.stars")?
            .withTintColor(.secondarySystemBackground)
            .withRenderingMode(.alwaysOriginal)
        return image!
    }

    private func constrainLabelsInsideClockFace() {
        let digitsDistanceFromCenter = ClockPainter.faceLabelsRadius(for: bounds)

        NSLayoutConstraint.activate([
            topDigits.topAnchor.constraint(equalTo: centerYAnchor, constant: -digitsDistanceFromCenter),
            rightDigits.trailingAnchor.constraint(equalTo: centerXAnchor, constant: digitsDistanceFromCenter),
            bottomDigits.bottomAnchor.constraint(equalTo: centerYAnchor, constant: digitsDistanceFromCenter),
            leftDigits.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -digitsDistanceFromCenter),
        ])
    }
}
