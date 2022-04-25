//
//  OnboardingController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

protocol OnboardingControllerDelegate {
    func startOnboarding()
}

class OnboardingController: UIViewController {
    //

    // MARK: - Related types
    
    //
    
    enum Step: Int, CaseIterable {
        //
        // EntiesList steps
        //
        case showTextGreeting
        case showTextName
//        case showTextFirstQuestion
//        case showTextSecondQuestion
        case showTextHint
        case showTextStartIsEasy
        case highlightBottomSection
        case showFloatingCircleUp
        case waitForSwipeUp
        case showTextGiveEventAName
        case waitForEventSubmit
        case highlightCreatedEntry
        case showTextEntryDescription
        case showTextTrySwipe
        case showFloatingCircleRight
        case waitForSwipe
        case showTextAfterSwipe01
        case showTextAfterSwipe02
        case showTextAfterSwipe03
        case showTextAfterSwipe04
        case showTextAfterSwipe05
        case highlightTestItem
        case showTextCreatedTestItem
        case showTextLongPress
        case highlightLongPress
        case waitForEntryDetailsPresentationAttempt
        case presentEntryDetailsController
        //
        // EntryDetails steps
        //
        case showTextEntryDetails
        case highlightPointsDisplay
        case showTextPointsDisplay
        case showTextPointsDisplayScroll
        case waitForPointsDisplayScroll
        case highlightStatsDisplay
        case showTextStatsDisplay
        case showTextStatsDisplayScroll
        case waitForScrollStatsDisplay
        case highlightDisplayWeek
        case showTextDisplayWeek
        case showTextDisplayWeekScroll
        case waitForDisplayWeekScroll
        case showTextFinal
    }
    
    //

    // MARK: - Properties

    //
    
    var animator: AnimatorOnboarding!
    var circleAnimator: AnimatorCircle!
    var backgroundAnimator: AnimatorBackground!

    private var tapMovesForward = true
    
    /// NEVER set current step with animation callback if tap is enabled by `enableTap`
    /// only after disabling tap with `disableTap`
    var currentStep: Step = .showTextGreeting {
        didSet {
            print("switching to \(currentStep)")
            perform(step: currentStep)
        }
    }
    
    var viewToHighlight: UIView!
    
    //

    // MARK: - Initialization

    //
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEventHandlers()
        setupAnimators()
    }
    
    private func setupEventHandlers() {
        if let view = view as? OnboardingView {
            view.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
            view.labelClose.addGestureRecognizer(
                UITapGestureRecognizer(target: self, action: #selector(handlePressClose)))
        
            view.labelClose.isUserInteractionEnabled = true
        } else {
            fatalError("view must be a subclass of OnboardingView")
        }
    }
    
    private func setupAnimators() {
        if let view = view as? OnboardingView {
            animator = AnimatorOnboarding(root: view)
            backgroundAnimator = AnimatorBackground(view.viewBackground)
            circleAnimator = AnimatorCircle(circle: view.viewCircle, finger: view.viewFinger, root: view)
        } else {
            fatalError("view must be a subclass of OnboardingView")
        }
    }
    
    //

    // MARK: - Events handling

    //
    
    @objc func handleTap() {
        if tapMovesForward { goToNextStep() }
    }
    
    @objc func handlePressClose() {
        finish()
    }
    
    //

    // MARK: - Internal behaviour

    //
    
    func start() {
        perform(step: currentStep)
    }
    
    func finish() {
        dismiss(animated: true)
    }
    
    func goToNextStep() {
        currentStep = Step(rawValue: currentStep.rawValue + 1)!
    }
    
    func perform(step: Step) {
        fatalError("this method must be overridden")
    }
    
    /// Must be switching with `disableTap` method
    func enableTap() {
        if let view = view as? OnboardingView {
            tapMovesForward = true
            view.isTransparentForTouches = false
            view.labelTapToProceed.layer.opacity = 1
            animator.show(labels: view.labelTapToProceed)
        } else {
            fatalError("view must be a subclass of OnboardingVie1w")
        }
    }
    
    func disableTap() {
        if let view = view as? OnboardingView {
            tapMovesForward = false
            view.isTransparentForTouches = true
            animator.hide(labels: view.labelTapToProceed)
        } else {
            fatalError("view must be a subclass of OnboardingView")
        }
    }
    
    //

    // MARK: - Notifications

    //
    
    func watch(_ name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(_:)), name: name, object: nil)
    }
    
    func ignore(_ name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
    
    @objc
    func handle(_ notification: Notification) {
        fatalError("this method must be overridden")
    }
}
