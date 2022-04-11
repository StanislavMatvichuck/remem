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
        case .highlightViewList:
            backgroundAnimator.show(view: viewToHighlight)
//        case waitForViewListPress
//        case highlightPointsList
//        case showTextPointsList
//        case showTextScrollPoints
//        case showFloatingCircleScrollPoints
//        case waitForScrollPoints
//        case highlightStats
//        case showTextStatsDescription
//        case showTextStatsScroll
//        case showFloatingCircleScrollStats
//        case waitForScrollStats
//        case highlightDisplay
//        case showTextDisplayDescription
//        case showTextDisplayScroll
//        case showFloatingCircleDisplayScroll
//        case waitForDisplayScroll
//        case showTextFinal
        default:
            fatalError("Unhandled step")
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
            let entryDetails = presentingViewController as? EntryDetailsController,
            let entriesListOnboarding = entryDetails.presentingViewController as? EntriesListOnboardingController
        else { return }

        dismiss(animated: true) {
            entryDetails.dismiss(animated: true) {
                entriesListOnboarding.finish()
            }
        }
    }
}
