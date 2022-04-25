//
//  ViewOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class EntriesListOnboardingView: OnboardingView {
    // MARK: - I18n
    static let start = NSLocalizedString(
        "onboarding.entriesList.start",
        comment: "onboarding entries list start")
    static let question01 = NSLocalizedString(
        "onboarding.entriesList.question1",
        comment: "onboarding entries list question 01")
    static let question02 = NSLocalizedString(
        "onboarding.entriesList.question2",
        comment: "onboarding entries list question 02")
    static let useCaseDescription = NSLocalizedString(
        "onboarding.entriesList.useCases",
        comment: "onboarding entries list use cases description")
    static let creationStart = NSLocalizedString(
        "onboarding.entriesList.entryCreation.start",
        comment: "onboarding entries list entry creation start")
    static let creationNaming = NSLocalizedString(
        "onboarding.entriesList.entryCreation.name",
        comment: "onboarding entries list entry creation naming")
    static let creationFinish = NSLocalizedString(
        "onboarding.entriesList.entryCreation.finish",
        comment: "onboarding entries list entry creation finished")
    static let addPoints = NSLocalizedString(
        "onboarding.entriesList.addPoints",
        comment: "onboarding entries list entry add points")
    static let addAdditionalPoints = NSLocalizedString(
        "onboarding.entriesList.addAdditionalPoints",
        comment: "onboarding entries list entry add additional points")
    static let filledEntryCreated = NSLocalizedString(
        "onboarding.entriesList.filledEntry.description",
        comment: "onboarding entries list test entry appeared")
    static let filledEntryInspect = NSLocalizedString(
        "onboarding.entriesList.filledEntry.inspect",
        comment: "onboarding entries list test entry inspect")
    
    lazy var labelMyNameIs: UILabel = {
        let label = createLabel()
        label.text = Self.start
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
//    lazy var labelQuestion01: UILabel = {
//        let label = createLabel()
//        label.text = Self.question01
//        label.topAnchor.constraint(equalTo: labelMyNameIs.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
//        return label
//    }()
//
//    lazy var labelQuestion02: UILabel = {
//        let label = createLabel()
//        label.text = Self.question02
//        label.topAnchor.constraint(equalTo: labelQuestion01.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
//        return label
//    }()
    
    lazy var labelHint: UILabel = {
        let label = createLabel()
        label.text = Self.useCaseDescription
        label.topAnchor.constraint(equalTo: labelMyNameIs.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelStart: UILabel = {
        let label = createLabel()
        label.text = Self.creationStart
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelEventName: UILabel = {
        let label = createLabel()
        label.text = Self.creationNaming
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelEventCreated: UILabel = {
        let label = createLabel()
        label.text = Self.creationFinish
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelEventSwipe: UILabel = {
        let label = createLabel()
        label.text = Self.addPoints
        label.topAnchor.constraint(equalTo: labelEventCreated.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelSwipeComplete: UILabel = {
        let label = createLabel()
        label.text = Self.addAdditionalPoints
        label.topAnchor.constraint(equalTo: labelEventSwipe.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelAdditionalSwipes: UILabel = {
        let label = createLabel()
        label.text = "1 / 5"
        label.font = .systemFont(ofSize: .font2, weight: .bold)
        label.topAnchor.constraint(equalTo: labelSwipeComplete.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelTestItemDescription: UILabel = {
        let label = createLabel()
        label.text = Self.filledEntryCreated
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
    
    lazy var labelTestItemLongPress: UILabel = {
        let label = createLabel()
        label.text = Self.filledEntryInspect
        label.topAnchor.constraint(equalTo: labelTestItemDescription.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        return label
    }()
}
