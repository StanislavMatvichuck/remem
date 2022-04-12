//
//  EntryDetailsOnboardingView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

class EntryDetailsOnboardingView: OnboardingView {
    lazy var labelScreenDescription: UILabel = {
        let label = createLabel()
        label.text = "Details screen description"
        label.topAnchor.constraint(equalTo: labelTapToProceed.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelPointsDisplayDescription: UILabel = {
        let label = createLabel()
        label.text = "Points list description"
        return label
    }()

    lazy var labelPointsDisplayDescriptionSecondary: UILabel = {
        let label = createLabel()
        label.text = "It is vertically scrollable. Try"
        label.topAnchor.constraint(equalTo: labelPointsDisplayDescription.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelStatsDisplayDescription: UILabel = {
        let label = createLabel()
        label.text = "Statistics description"
        return label
    }()

    lazy var labelStatsDisplayDescriptionSecondary: UILabel = {
        let label = createLabel()
        label.text = "Statistics is scrollable"
        label.topAnchor.constraint(equalTo: labelStatsDisplayDescription.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelWeekDisplayDescription: UILabel = {
        let label = createLabel()
        label.text = "Week display"
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelWeekDisplayDescriptionSecondary: UILabel = {
        let label = createLabel()
        label.text = "Week display is scrollable"
        label.topAnchor.constraint(equalTo: labelWeekDisplayDescription.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()

    lazy var labelFinal: UILabel = {
        let label = createLabel()
        label.text = "Final text"
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor,
                                   constant: labelsVerticalSpacing).isActive = true
        return label
    }()
}
