//
//  EntryDetailsOnboardingController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

class EntryDetailsOnboardingController: OnboardingController {
    let viewRoot = EntryDetailsOnboardingView()

    override func loadView() {
        view = viewRoot
    }

    override func perform(step: OnboardingController.Step) {
        switch step {
        case .showTextEntryDetails:
            enableTap()

            viewRoot.labelTitle.text = "Details screen"

            animator.show(labels: viewRoot.labelTitle,
                          viewRoot.labelClose,
                          viewRoot.labelScreenDescription)
        case .highlightPointsDisplay:
            disableTap()

            viewRoot.placeTapToProceedInsteadOfTitle()
            let constant = viewToHighlight.frame.maxY + viewRoot.labelsVerticalSpacing
            viewRoot.labelPointsDisplayDescription.topAnchor.constraint(equalTo: viewRoot.topAnchor,
                                                                        constant: constant).isActive = true

            viewRoot.labelTitle.isHidden = true
            viewRoot.labelScreenDescription.isHidden = true

            animator.hide(labels: viewRoot.labelTitle,
                          viewRoot.labelScreenDescription) {
                self.backgroundAnimator.show(view: self.viewToHighlight, cornerRadius: .xs) {
                    self.currentStep = .showTextPointsDisplay
                }
            }
        case .showTextPointsDisplay:
            enableTap()
            animator.show(labels: viewRoot.labelPointsDisplayDescription)
        case .showTextPointsDisplayScroll:
            disableTap()
//            animator.hide(labels: viewRoot.labelTapToProceed)
            animator.show(labels: viewRoot.labelPointsDisplayDescriptionSecondary) {
                self.currentStep = .waitForPointsDisplayScroll
            }
        case .waitForPointsDisplayScroll:
            watch(.PointsDisplayDidScroll)
            circleAnimator.start(.scrollPointsDisplay(view: viewToHighlight))
        case .highlightStatsDisplay:
            ignore(.PointsDisplayDidScroll)

            circleAnimator.stop()

            animator.hide(labels: viewRoot.labelPointsDisplayDescription, viewRoot.labelPointsDisplayDescriptionSecondary)

            backgroundAnimator.hide {
                self.backgroundAnimator.show(view: self.viewToHighlight, offset: .delta1) {
                    self.currentStep = .showTextStatsDisplay
                }
            }
        case .showTextStatsDisplay:
            enableTap()

            let constant = viewToHighlight.frame.maxY + viewRoot.labelsVerticalSpacing
            viewRoot.labelStatsDisplayDescription.topAnchor.constraint(equalTo: viewRoot.topAnchor,
                                                                       constant: constant).isActive = true

            animator.show(labels: viewRoot.labelStatsDisplayDescription)

        case .showTextStatsDisplayScroll:
            disableTap()
            animator.show(labels: viewRoot.labelStatsDisplayDescriptionSecondary) {
                self.currentStep = .waitForScrollStatsDisplay
            }
        case .waitForScrollStatsDisplay:
            watch(.StatsDisplayDidScroll)
            circleAnimator.start(.scrollStatsDisplay(view: viewToHighlight))
        case .highlightDisplayWeek:
            ignore(.StatsDisplayDidScroll)

            circleAnimator.stop()

            animator.hide(labels: viewRoot.labelStatsDisplayDescription, viewRoot.labelStatsDisplayDescriptionSecondary)

            backgroundAnimator.show(view: viewToHighlight) {
                self.currentStep = .showTextDisplayWeek
            }

        case .showTextDisplayWeek:
            enableTap()
            animator.show(labels: viewRoot.labelWeekDisplayDescription)
        case .showTextDisplayWeekScroll:
            disableTap()
            animator.show(labels: viewRoot.labelWeekDisplayDescriptionSecondary) {
                self.currentStep = .waitForDisplayWeekScroll
            }
        case .waitForDisplayWeekScroll:
            watch(.WeekDisplayDidScroll)
            circleAnimator.start(.scrollWeekDisplay(view: viewToHighlight))
        case .showTextFinal:
            backgroundAnimator.hide()

            circleAnimator.stop()

            animator.hide(labels: viewRoot.labelWeekDisplayDescription, viewRoot.labelWeekDisplayDescriptionSecondary)

            animator.show(labels: viewRoot.labelFinal)
        default:
            fatalError("Unhandled step")
        }
    }

    override func handle(_ notification: Notification) {
        switch notification.name {
        case .PointsDisplayDidScroll:
            if let view = notification.object as? UIView {
                viewToHighlight = view
                currentStep = .highlightStatsDisplay
            }
        case .StatsDisplayDidScroll:
            if let view = notification.object as? UIView {
                viewToHighlight = view
                currentStep = .highlightDisplayWeek
            }

        case .WeekDisplayDidScroll:
            currentStep = .showTextFinal
        default:
            fatalError("Unhandled case \(notification.name)")
        }
    }

    init(withStep: Step) {
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func start() {
        currentStep = .showTextEntryDetails
    }

    override func finish() {
        guard
            let entryDetailsContainer = presentingViewController as? UINavigationController,
            let entryDetails = entryDetailsContainer.viewControllers[0] as? EntryDetailsController,
            let entriesListOnboarding = entryDetails.presentingViewController as? EntriesListOnboardingController
        else { return }

        dismiss(animated: true) {
            entryDetails.dismiss(animated: true) {
                entriesListOnboarding.finish()
            }
        }
    }
}
