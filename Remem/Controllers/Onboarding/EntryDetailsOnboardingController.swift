//
//  EntryDetailsOnboardingController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

// protocol EntriesListOnboardingControllerDataSource: UIViewController {
//    var viewSwiper: UIView { get }
//    var viewInput: UIView { get }
// }
//
// protocol EntriesListOnboardingControllerDelegate: UIViewController {
//    func createTestItem()
//    func disableSettingsButton()
//    func enableSettingsButton()
// }

class EntryDetailsOnboardingController: OnboardingController {
    let viewRoot = EntryDetailsOnboardingView()

    override func loadView() {
        view = viewRoot
    }

    override func perform(step: OnboardingController.Step) {
        switch step {
        case .showTextEntryDetails:
            viewRoot.labelTitle.text = "Details screen"
            animator.show(label: viewRoot.labelTitle)
            animator.show(label: viewRoot.labelTapToProceed)
            animator.show(label: viewRoot.labelClose)
            animator.show(label: viewRoot.labelScreenDescription)
        case .highlightPointsDisplay:
            viewRoot.placeTapToProceedInsteadOfTitle()

            let constant = viewToHighlight.frame.maxY + viewRoot.labelsVerticalSpacing
            viewRoot.labelPointsDisplayDescription.topAnchor.constraint(equalTo: viewRoot.topAnchor,
                                                                        constant: constant).isActive = true

            viewRoot.labelTitle.isHidden = true
            viewRoot.labelScreenDescription.isHidden = true

            backgroundAnimator.show(view: viewToHighlight, cornerRadius: .xs) {
                self.currentStep = .showTextPointsDisplay
            }
        case .showTextPointsDisplay:
            animator.show(label: viewRoot.labelPointsDisplayDescription)
        case .showTextPointsDisplayScroll:
            animator.hide(label: viewRoot.labelTapToProceed)
            animator.show(label: viewRoot.labelPointsDisplayDescriptionSecondary) {
                self.currentStep = .waitForPointsDisplayScroll
            }
        case .waitForPointsDisplayScroll:
            watch(.PointsDisplayDidScroll)
            circleAnimator.start(.scrollPointsDisplay(view: viewToHighlight))
            disableTap()
        case .highlightStatsDisplay:
            ignore(.PointsDisplayDidScroll)
            animator.hide(label: viewRoot.labelPointsDisplayDescription)
            animator.hide(label: viewRoot.labelPointsDisplayDescriptionSecondary)
            circleAnimator.stop()
            backgroundAnimator.hide {
                self.backgroundAnimator.show(view: self.viewToHighlight) {
                    self.currentStep = .showTextStatsDisplay
                }
            }
        case .showTextStatsDisplay:
            let constant = viewToHighlight.frame.maxY + viewRoot.labelsVerticalSpacing
            viewRoot.labelStatsDisplayDescription.topAnchor.constraint(equalTo: viewRoot.topAnchor,
                                                                       constant: constant).isActive = true
            animator.show(label: viewRoot.labelStatsDisplayDescription)
            enableTap()
        case .showTextStatsDisplayScroll:
            animator.show(label: viewRoot.labelStatsDisplayDescriptionSecondary) {
                self.currentStep = .waitForScrollStatsDisplay
            }
        case .waitForScrollStatsDisplay:
            watch(.StatsDisplayDidScroll)
            disableTap()
            circleAnimator.start(.scrollStatsDisplay(view: viewToHighlight))
        case .highlightDisplayWeek:
            ignore(.StatsDisplayDidScroll)
            animator.hide(label: viewRoot.labelStatsDisplayDescription)
            animator.hide(label: viewRoot.labelStatsDisplayDescriptionSecondary)
            circleAnimator.stop()
            backgroundAnimator.show(view: viewToHighlight) {
                self.currentStep = .showTextDisplayWeek
            }

        case .showTextDisplayWeek:
            animator.show(label: viewRoot.labelWeekDisplayDescription)
            enableTap()
        case .showTextDisplayWeekScroll:
            animator.show(label: viewRoot.labelWeekDisplayDescriptionSecondary) {
                self.currentStep = .waitForDisplayWeekScroll
            }
        case .waitForDisplayWeekScroll:
            watch(.WeekDisplayDidScroll)
            circleAnimator.start(.scrollWeekDisplay(view: viewToHighlight))
            disableTap()
        case .showTextFinal:
            backgroundAnimator.hide()
            circleAnimator.stop()
            animator.hide(label: viewRoot.labelWeekDisplayDescription)
            animator.hide(label: viewRoot.labelWeekDisplayDescriptionSecondary)
            animator.show(label: viewRoot.labelFinal)
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
