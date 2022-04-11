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
    
    private lazy var labelNameBottomConstraint: NSLayoutConstraint = {
        viewRoot.labelEventName.bottomAnchor.constraint(
            equalTo: viewRoot.bottomAnchor,
            constant: 300)
    }()
    
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
            animator.show(label: viewRoot.labelTitle)
            animator.show(label: viewRoot.labelTapToProceed)
            animator.show(label: viewRoot.labelClose)
        case .showTextName:
            animator.show(label: viewRoot.labelMyNameIs)
            animator.hide(label: viewRoot.labelTapToProceed)
        case .showTextFirstQuestion:
            animator.show(label: viewRoot.labelQuestion01)
        case .showTextSecondQuestion:
            animator.show(label: viewRoot.labelQuestion02)
        case .showTextHint:
            animator.show(label: viewRoot.labelHint)
        case .showTextStartIsEasy:
            viewRoot.labelTitle.text = " "
            animator.hide(label: viewRoot.labelMyNameIs)
            animator.hide(label: viewRoot.labelQuestion01)
            animator.hide(label: viewRoot.labelQuestion02)
            animator.hide(label: viewRoot.labelHint)
            
            animator.show(label: viewRoot.labelStart)
            currentStep = .highlightBottomSection
        case .highlightBottomSection:
            backgroundAnimator.show(view: mainDataSource.viewSwiper, cornerRadius: 0, offset: 0)
            currentStep = .showFloatingCircleUp
        case .showFloatingCircleUp:
            circleAnimator.start(.addItem)
            currentStep = .waitForSwipeUp
        case .waitForSwipeUp:
            watch(.UIMovableTextViewShown)
            tapMovesForward = false
            viewRoot.isTransparentForTouches = true
        case .showTextGiveEventAName:
            ignore(.UIMovableTextViewShown)
            watch(.UIMovableTextViewWillShow)
            viewRoot.isTransparentForTouches = false
            labelNameBottomConstraint.isActive = true
            
            animator.hide(label: viewRoot.labelStart)
            circleAnimator.stop()
            animator.show(label: viewRoot.labelEventName)
            backgroundAnimator.show(view: viewToHighlight, cornerRadius: .r1, offset: 0)
    
            currentStep = .waitForEventSubmit
        case .waitForEventSubmit:
            watch(.EntriesListNewEntry)
        case .highlightCreatedEntry:
            ignore(.UIMovableTextViewWillShow)
            ignore(.EntriesListNewEntry)
            
            viewRoot.labelEventName.isHidden = true
            tapMovesForward = true
            
            backgroundAnimator.show(view: viewToHighlight)
            currentStep = .showTextEntryDescription
        case .showTextEntryDescription:
            animator.show(label: viewRoot.labelEventCreated)
        case .showTextTrySwipe:
            animator.show(label: viewRoot.labelEventSwipe)
            tapMovesForward = false
            currentStep = .showFloatingCircleRight
        case .showFloatingCircleRight:
            circleAnimator.start(.addPoint)
            currentStep = .waitForSwipe
        case .waitForSwipe:
            watch(.EntriesListNewPoint)
            viewRoot.isTransparentForTouches = true
        case .showTextAfterSwipe01:
            circleAnimator.stop()
            animator.show(label: viewRoot.labelSwipeComplete)
        case .showTextAfterSwipe02:
            animator.show(label: viewRoot.labelAdditionalSwipes)
        case .showTextAfterSwipe03:
            viewRoot.labelAdditionalSwipes.text = "3 / 5"
        case .showTextAfterSwipe04:
            viewRoot.labelAdditionalSwipes.text = "4 / 5"
        case .showTextAfterSwipe05:
            viewRoot.labelAdditionalSwipes.text = "5 / 5"
            watch(.EntriesListNewEntry)
            ignore(.EntriesListNewPoint)
            mainDelegate.createTestItem()
            tapMovesForward = false
        case .highlightTestItem:
            ignore(.EntriesListNewEntry)
            backgroundAnimator.show(view: viewToHighlight)
            currentStep = .showTextCreatedTestItem
        case .showTextCreatedTestItem:
            animator.hide(label: viewRoot.labelEventCreated)
            animator.hide(label: viewRoot.labelEventSwipe)
            animator.hide(label: viewRoot.labelAdditionalSwipes)
            animator.hide(label: viewRoot.labelSwipeComplete)
            
            animator.show(label: viewRoot.labelTestItemDescription)
            tapMovesForward = true
            viewRoot.isTransparentForTouches = false
        case .showTextLongPress:
            animator.show(label: viewRoot.labelTestItemLongPress)
            currentStep = .highlightLongPress
        case .highlightLongPress:
            if let cell = viewToHighlight as? EntryCell {
                backgroundAnimator.move(to: cell.viewMovable)
            }
            currentStep = .waitForEntryDetailsPresentationAttempt
        case .waitForEntryDetailsPresentationAttempt:
            tapMovesForward = false
            viewRoot.isTransparentForTouches = true
            watch(.EntriesListDetailsPresentationAttempt)
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
