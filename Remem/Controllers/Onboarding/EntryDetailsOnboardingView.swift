//
//  EntryDetailsOnboardingView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

class EntryDetailsOnboardingView: OnboardingView {
    // MARK: - I18n
    static let start = NSLocalizedString("onboarding.entryDetails.start",
                                         comment: "onboarding entry details start")
    static let pointsDescription = NSLocalizedString("onboarding.entryDetails.pointsList.description",
                                                     comment: "onboarding entry details points display description")
    static let pointsScrollable = NSLocalizedString("onboarding.entryDetails.pointsList.scrollable",
                                                    comment: "onboarding entry details points display scrollable")
    static let statsDescription = NSLocalizedString("onboarding.entryDetails.stats.description",
                                                    comment: "onboarding entry details stats display description")
    static let statsScrollable = NSLocalizedString("onboarding.entryDetails.stats.scrollable",
                                                   comment: "onboarding entry details stats display scrollable")
    static let weekDescription = NSLocalizedString("onboarding.entryDetails.week.description",
                                                   comment: "onboarding entry details week display description")
    static let weekScrollable = NSLocalizedString("onboarding.entryDetails.week.scrollable",
                                                  comment: "onboarding entry details week display scrollable")
    static let final = NSLocalizedString("onboarding.entryDetails.final",
                                         comment: "onboarding entry details final")

    lazy var labelScreenDescription: UILabel = {
        let label = createLabel()
        label.text = Self.start
        label.topAnchor.constraint(equalTo: labelTapToProceed.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelPointsDisplayDescription: UILabel = {
        let label = createLabel()
        label.text = Self.pointsDescription
        return label
    }()

    lazy var labelPointsDisplayDescriptionSecondary: UILabel = {
        let label = createLabel()
        label.text = Self.pointsScrollable
        label.topAnchor.constraint(equalTo: labelPointsDisplayDescription.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelStatsDisplayDescription: UILabel = {
        let label = createLabel()
        label.text = Self.statsDescription
        return label
    }()

    lazy var labelStatsDisplayDescriptionSecondary: UILabel = {
        let label = createLabel()
        label.text = Self.statsScrollable
        label.topAnchor.constraint(equalTo: labelStatsDisplayDescription.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelWeekDisplayDescription: UILabel = {
        let label = createLabel()
        label.text = Self.weekDescription
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelWeekDisplayDescriptionSecondary: UILabel = {
        let label = createLabel()
        label.text = Self.weekScrollable
        label.topAnchor.constraint(equalTo: labelWeekDisplayDescription.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelFinal: UILabel = {
        let label = createLabel()
        label.text = Self.final
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()
}
