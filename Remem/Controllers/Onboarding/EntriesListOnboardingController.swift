//
//  ControllerOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

protocol EntriesListOnboardingControllerDataSource: UIViewController {
    var viewSwiper: UIView { get }
    var viewInput: UIView { get }
}

protocol EntriesListOnboardingControllerDelegate: UIViewController, OnboardingControllerDelegate {
    func createTestItem()
    func prepareForOnboardingStart()
    func prepareForOnboardingEnd()
}

class EntriesListOnboardingController: OnboardingController {
    //

    // MARK: - Public properties

    //
    
    weak var mainDataSource: EntriesListOnboardingControllerDataSource!
    weak var mainDelegate: EntriesListOnboardingControllerDelegate!
    
    //
    
    // MARK: - Private properties
    
    //
    
    //
    
    // MARK: - Initialization
    
    //
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    let viewRoot = EntriesListOnboardingView()
    
    override func loadView() {
        view = viewRoot
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupEventHandlers()
//    }
    
    //

    // MARK: - Events handling

    //
    
    //

    // MARK: - Behaviour

    //
    
    override func start() {
        super.start()
        mainDelegate.prepareForOnboardingStart()
    }
    
    override func finish() {
        mainDelegate.prepareForOnboardingEnd()
        super.finish()
    }
    
    override func perform(step: Step) {
        switch step {
        case .showTextGreeting:
            animator.show(labels: viewRoot.labelTitle,
                          viewRoot.labelTapToProceed,
                          viewRoot.labelClose)
        case .showTextName:
            animator.show(labels: viewRoot.labelMyNameIs)
            animator.hide(labels: viewRoot.labelTapToProceed)
//        case .showTextFirstQuestion:
//            animator.show(labels: viewRoot.labelQuestion01)
//        case .showTextSecondQuestion:
//            animator.show(labels: viewRoot.labelQuestion02)
        case .showTextHint:
            animator.show(labels: viewRoot.labelHint)
        case .showTextStartIsEasy:
            disableTap()
            
            viewRoot.labelTitle.text = " "
            
            animator.hide(labels:
                viewRoot.labelMyNameIs,
//                viewRoot.labelQuestion01,
//                viewRoot.labelQuestion02,
                viewRoot.labelHint)
            
            animator.show(labels: viewRoot.labelStart) {
                self.currentStep = .highlightBottomSection
            }
        case .highlightBottomSection:
            backgroundAnimator.show(view: mainDataSource.viewSwiper, cornerRadius: 0, offset: 0) {
                self.currentStep = .showFloatingCircleUp
            }
        case .showFloatingCircleUp:
            circleAnimator.start(.addItem)
            currentStep = .waitForSwipeUp
        case .waitForSwipeUp:
            watch(.UIMovableTextViewShown)
        case .showTextGiveEventAName:
            ignore(.UIMovableTextViewShown)
            watch(.UIMovableTextViewWillShow)
            
            // to abandon dismissing?
            // TODO: make MovableTextView ignore bg presses during cancel disabled, remove this line after
            viewRoot.isTransparentForTouches = false
            
            animator.hide(labels: viewRoot.labelStart)
            animator.show(labels: viewRoot.labelEventName)
            backgroundAnimator.show(view: viewToHighlight, cornerRadius: .r1, offset: 0)
            circleAnimator.stop()
            
            currentStep = .waitForEventSubmit
        case .waitForEventSubmit:
            watch(.EntriesListNewEntry)
        case .highlightCreatedEntry:
            ignore(.UIMovableTextViewWillShow)
            ignore(.EntriesListNewEntry)
            
            viewRoot.labelEventName.isHidden = true
            
            backgroundAnimator.show(view: viewToHighlight)
            currentStep = .showTextEntryDescription
        case .showTextEntryDescription:
            viewRoot.placeTapToProceedInsteadOfTitle()
            enableTap()
            animator.show(labels: viewRoot.labelEventCreated)
        case .showTextTrySwipe:
            disableTap()
            animator.show(labels: viewRoot.labelEventSwipe) {
                self.currentStep = .showFloatingCircleRight
            }
        case .showFloatingCircleRight:
            circleAnimator.start(.addPoint)
            currentStep = .waitForSwipe
        case .waitForSwipe:
            watch(.EntriesListNewPoint)
        case .showTextAfterSwipe01:
            circleAnimator.stop()
            animator.show(labels: viewRoot.labelSwipeComplete, viewRoot.labelAdditionalSwipes)
        case .showTextAfterSwipe02:
            viewRoot.labelAdditionalSwipes.text = "2 / 5"
        case .showTextAfterSwipe03:
            viewRoot.labelAdditionalSwipes.text = "3 / 5"
        case .showTextAfterSwipe04:
            viewRoot.labelAdditionalSwipes.text = "4 / 5"
        case .showTextAfterSwipe05:
            viewRoot.labelAdditionalSwipes.text = "5 / 5"
            
            watch(.EntriesListNewEntry)
            ignore(.EntriesListNewPoint)
            
            mainDelegate.createTestItem()
        case .highlightTestItem:
            ignore(.EntriesListNewEntry)
            
            backgroundAnimator.hide {
                self.backgroundAnimator.show(view: self.viewToHighlight) {
                    self.currentStep = .showTextCreatedTestItem
                }
            }
        case .showTextCreatedTestItem:
            enableTap()
            
            animator.hide(labels: viewRoot.labelEventCreated,
                          viewRoot.labelEventSwipe,
                          viewRoot.labelAdditionalSwipes,
                          viewRoot.labelSwipeComplete) {
                self.animator.show(labels: self.viewRoot.labelTestItemDescription)
            }
        case .showTextLongPress:
            disableTap()
            animator.show(labels: viewRoot.labelTestItemLongPress) {
                self.currentStep = .highlightLongPress
            }
        case .highlightLongPress:
            if let cell = viewToHighlight as? EntryCell {
                backgroundAnimator.hide {
                    self.backgroundAnimator.show(view: cell.viewMovable, cornerRadius: .r2, offset: .delta1) {
                        self.currentStep = .waitForEntryDetailsPresentationAttempt
                    }
                }
            }
            
        case .waitForEntryDetailsPresentationAttempt:
            watch(.EntriesListDetailsPresentationAttempt)
            
            animator.hide(labels: viewRoot.labelTapToProceed)
            
        default:
            fatalError("⚠️ unhandled onboarding case")
        }
    }
    
    override func handle(_ notification: Notification) {
        switch notification.name {
        case .UIMovableTextViewShown:
            if let view = notification.object as? UIView {
                viewToHighlight = view
                currentStep = .showTextGiveEventAName
            }
        case .UIMovableTextViewWillShow:
            if let descriptor = notification.object as? UIMovableTextView.KeyboardHeightChangeDescriptor {
                backgroundAnimator.moveShownArea(by: descriptor.movedBy, duration: descriptor.duration)
            }
        case .EntriesListNewEntry:
            guard let cell = notification.object as? UITableViewCell else { return }
            viewToHighlight = cell
            
            if currentStep == .showTextAfterSwipe05 {
                currentStep = .highlightTestItem
            } else {
                currentStep = .highlightCreatedEntry
            }
        case .EntriesListNewPoint:
            goToNextStep()
        case .EntriesListDetailsPresentationAttempt:
            if let preparedEntryDetailsController = notification.object as? UINavigationController {
                preparedEntryDetailsController.isModalInPresentation = true
                present(preparedEntryDetailsController, animated: true) {
                    if let controller = preparedEntryDetailsController.viewControllers[0] as? OnboardingControllerDelegate {
                        controller.startOnboarding()
                    }
                }
            }
        default:
            fatalError("Unhandled notification")
        }
    }
}
