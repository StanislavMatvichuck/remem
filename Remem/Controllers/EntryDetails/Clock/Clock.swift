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
    private var painter: ClockPainter?
    var sectionsList: ClockSectionDescriptionsList!

    lazy var topDigits: UILabel = makeLabel(variant == .day ? "12" : "00")
    lazy var rightDigits: UILabel = makeLabel(variant == .day ? "15" : "03")
    lazy var bottomDigits: UILabel = makeLabel(variant == .day ? "18" : "06")
    lazy var leftDigits: UILabel = makeLabel(variant == .day ? "21" : "09")

    // MARK: - Init
    init(for variant: ClockVariant) {
        self.variant = variant
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addLabels()
        addIcon()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func layoutSubviews() {
        if painter == nil {
            painter = ClockPainter(rect: bounds, sectionsList: sectionsList)
        }

        let digitsDistanceFromCenter = painter!.faceInnerRadius
        NSLayoutConstraint.activate([
            topDigits.topAnchor.constraint(equalTo: centerYAnchor, constant: -digitsDistanceFromCenter),
            rightDigits.trailingAnchor.constraint(equalTo: centerXAnchor, constant: digitsDistanceFromCenter),
            bottomDigits.bottomAnchor.constraint(equalTo: centerYAnchor, constant: digitsDistanceFromCenter),
            leftDigits.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -digitsDistanceFromCenter),
        ])

        super.layoutSubviews()
    }

    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        painter?.draw(in: context)
    }
}

// MARK: - Public
extension Clock {
    func redraw() {
        setNeedsDisplay()
    }
}

// MARK: - Private
extension Clock {
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
        label.font = .systemFont(ofSize: 0.8 * .font1)
        return label
    }

    private func addIcon() {
        let imageView = UIImageView(image: makeIcon())
        imageView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func makeIcon() -> UIImage {
        let image = UIImage(systemName: variant == .day ? "sun.max" : "moon.stars")?
            .withTintColor(.secondarySystemBackground)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))

        return image!
    }
}
