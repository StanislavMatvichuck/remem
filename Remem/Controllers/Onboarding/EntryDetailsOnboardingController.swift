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

//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }

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
            viewRoot.isTransparentForTouches = true
        case .highlightStatsDisplay:
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
//        case showTextStatsDisplayScroll
//        case waitForScrollStatsDisplay
//        case highlightDisplayWeek
//        case showTextDisplayWeek
//        case showTextDisplayWeekScroll
//        case waitForDisplayWeekScroll
//        case showTextFinal
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
