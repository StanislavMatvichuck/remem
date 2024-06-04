//
//  WeekDayView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 22.12.2023.
//

import UIKit

final class WeekDayView: UIStackView {
    private let roundContainer: UIStackView = {
        let roundView = UIStackView(al: true)
        roundView.axis = .vertical
        roundView.alignment = .fill
        return roundView
    }()

    private let happenings = WeekDayHappeningView()
    private let dayNumber = WeekDayNumberView()
    private let dayName: UILabel = {
        let label = UILabel(al: true)
        label.font = .font
        label.textAlignment = .center
        return label
    }()

    var viewModel: WeekDayViewModel? { didSet {
        guard let viewModel else { return }
        configureContent(viewModel)
    }}

    var service: ShowDayDetailsService?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isAccessibilityElement = true
        accessibilityIdentifier = UITestID.weekDay.rawValue
        configureLayout()
        configureAppearance()
    }

    required init(coder: NSCoder) { fatalError(errorUIKitInit) }

    private func configureAppearance() {
        dayName.textColor = .secondary
        roundContainer.layer.cornerRadius = .layoutSquare / 10 * 1.6
        roundContainer.clipsToBounds = true
        roundContainer.backgroundColor = .bg_item
    }

    private func configureContent(_ viewModel: WeekDayViewModel) {
        dayName.text = viewModel.dayName

        dayNumber.configureContent(viewModel)
        happenings.configureContent(viewModel)

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        roundContainer.addGestureRecognizer(tapRecognizer)
    }

    @objc private func handleTap() {
        guard let daysContainer = superview,
              let weekContainer = daysContainer.superview
        else { return }

        let presentationAnimationBlock = { [weak self, weak weekContainer] in
            guard let self, let weekContainer else { return }

            UIView.animateKeyframes(
                withDuration: DayDetailsAnimationsHelper.totalDuration,
                delay: 0,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 0,
                        relativeDuration: 1 / 3,
                        animations: {
                            self.frame.origin.y = self.frame.origin.y - weekContainer.frame.maxY
                        }
                    )

                    UIView.addKeyframe(
                        withRelativeStartTime: 0,
                        relativeDuration: 1 / 6,
                        animations: {
                            self.transform = .init(scaleX: 0.8, y: 1)
                        }
                    )
                }
            )
        }

        let dismissAnimationBlock = { [weak self] in
            guard let self else { return }
            UIView.animateKeyframes(
                withDuration: DayDetailsAnimationsHelper.totalDuration,
                delay: 0,
                animations: {
                    UIView.addKeyframe(
                        withRelativeStartTime: 3 / 6,
                        relativeDuration: 1 / 2,
                        animations: {
                            self.frame.origin.y = 0
                        }
                    )

                    UIView.addKeyframe(
                        withRelativeStartTime: 5 / 6,
                        relativeDuration: 1 / 6,
                        animations: {
                            self.transform = .identity
                        }
                    )
                }
            )
        }

        if let viewModel, let service {
            service.serve(ShowDayDetailsServiceArgument(
                startOfDay: viewModel.startOfDay,
                eventId: viewModel.eventId,
                presentationAnimation: presentationAnimationBlock,
                dismissAnimation: dismissAnimationBlock
            ))
        }
    }

    private func configureLayout() {
        axis = .vertical

        roundContainer.addArrangedSubview(happenings)
        roundContainer.addArrangedSubview(dayNumber)

        addArrangedSubview(roundContainer)
        addArrangedSubview(dayName)
        dayName.widthAnchor.constraint(equalTo: widthAnchor).isActive = true

        setCustomSpacing(WeekPageView.daySpacing, after: roundContainer)
    }
}
