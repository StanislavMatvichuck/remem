//
//  Clock.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 11.05.2022.
//

import UIKit

final class ClockView: UIView {
    private static let digitsAngle = CGFloat.pi / 6
    private static let digitsAngleOffset = -CGFloat.pi / 2

    let clockFace: ClockFace
    var viewModel: ClockViewModel
    private var digitsInstalled = false
    private var iconsInstalled = false
    private var digitsRadius: CGFloat { bounds.width / 4.5 }

    // MARK: - Init
    init(viewModel: ClockViewModel) {
        self.clockFace = ClockFace(viewModel: viewModel)
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        addSubview(clockFace)

        NSLayoutConstraint.activate([
            clockFace.widthAnchor.constraint(equalTo: widthAnchor),
            clockFace.heightAnchor.constraint(equalTo: heightAnchor),
            clockFace.centerXAnchor.constraint(equalTo: centerXAnchor),
            clockFace.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureDigits()
        addIcons()
    }

    private func configureDigits() {
        guard !digitsInstalled else { return }

        let digitsLabels = viewModel.type.symbols.enumerated().map {
            $0 % 3 == 0 ?
                Self.makeCapitalizedLabel($1) :
                Self.makeLabel($1)
        }

        for (index, label) in digitsLabels.enumerated() {
            addSubview(label)
            label.centerXAnchor.constraint(equalTo: centerXAnchor, constant: xForDigit(index)).isActive = true
            label.centerYAnchor.constraint(equalTo: centerYAnchor, constant: yForDigit(index)).isActive = true
        }

        digitsInstalled = true
    }

    private func xForDigit(_ index: Int) -> CGFloat {
        let angle = Self.digitsAngle * CGFloat(index) + Self.digitsAngleOffset
        return digitsRadius * cos(angle)
    }

    private func yForDigit(_ index: Int) -> CGFloat {
        let angle = Self.digitsAngle * CGFloat(index) + Self.digitsAngleOffset
        return digitsRadius * sin(angle)
    }

    private func addIcons() {
        guard !iconsInstalled else { return }

        let imageViewDay = makeIcon(name: viewModel.type.imageName)

        addSubview(imageViewDay)

        imageViewDay.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageViewDay.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        iconsInstalled = true
    }

    private static func makeLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = .fontClock
        label.textColor = UIColor.secondary
        return label
    }

    private static func makeCapitalizedLabel(_ text: String) -> UILabel {
        let label = UILabel(al: true)
        label.text = text
        label.font = .fontClockCapitalised
        label.textColor = UIColor.secondary
        return label
    }

    private func makeIcon(name: String) -> UIImageView {
        let image = UIImage(systemName: name)?
            .withTintColor(UIColor.bg_secondary)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))

        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }
}
