//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

class Clock: UIView {
    // MARK: - Properties
    let variant: ClockController.ClockVariant

    lazy var clockFace = ClockFace(variant: variant)
    lazy var iconContainer = UIView(al: true)
    lazy var topDigits: UILabel = makeLabel(variant == .day ? "12" : "00")
    lazy var rightDigits: UILabel = makeLabel(variant == .day ? "15" : "03")
    lazy var bottomDigits: UILabel = makeLabel(variant == .day ? "18" : "06")
    lazy var leftDigits: UILabel = makeLabel(variant == .day ? "21" : "09")

    private var labelsConstrained = false

    // MARK: - Init
    init(for variant: ClockController.ClockVariant) {
        self.variant = variant

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()

        constrainLabelsInsideClockFace()
        iconContainer.layer.cornerRadius = iconContainer.layer.frame.width / 2
    }
}

// MARK: - Private
extension Clock {
    private func setupLayout() {
        addLabels()
        addIcon()
        addClock()
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

    private func addIcon() {
        let imageView = UIImageView(image: makeIcon())
        imageView.translatesAutoresizingMaskIntoConstraints = false

        iconContainer.backgroundColor = .systemBackground
        iconContainer.addAndConstrain(imageView, constant: 5)
        addSubview(iconContainer)

        NSLayoutConstraint.activate([
            iconContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30.0),

            iconContainer.widthAnchor.constraint(equalToConstant: 32.0),
            iconContainer.heightAnchor.constraint(equalToConstant: 32.0),
        ])
    }

    private func addClock() {
        clockFace.translatesAutoresizingMaskIntoConstraints = false
        addAndConstrain(clockFace)
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = UIHelper.fontSmallBold
        label.textColor = UIHelper.clockSectionBackground
        return label
    }

    private func makeIcon() -> UIImage {
        let image = UIImage(systemName: variant == .day ? "sun.max" : "moon.stars")?
            .withTintColor(UIHelper.clockSectionBackground)
            .withRenderingMode(.alwaysOriginal)
        return image!
    }

    private func constrainLabelsInsideClockFace() {
        guard labelsConstrained == false else { return }

        let digitsDistanceFromCenter = bounds.height / 3

        NSLayoutConstraint.activate([
            topDigits.topAnchor.constraint(equalTo: centerYAnchor, constant: -digitsDistanceFromCenter),
            rightDigits.trailingAnchor.constraint(equalTo: centerXAnchor, constant: digitsDistanceFromCenter),
            bottomDigits.bottomAnchor.constraint(equalTo: centerYAnchor, constant: digitsDistanceFromCenter),
            leftDigits.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -digitsDistanceFromCenter),
        ])

        labelsConstrained = true
    }
}
