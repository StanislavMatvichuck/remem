//
//  OnboardingController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

class OnboardingController: UIViewController {
    //

    // MARK: - Related types
    
    //
    
    enum Step: Int, CaseIterable {
        case showTextGreeting
        case showTextName
        case showTextFirstQuestion
        case showTextSecondQuestion
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
//        case highlightViewList
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
    }
    
    //

    // MARK: - Properties

    //
    
    var animator: AnimatorOnboarding!
    var circleAnimator: AnimatorCircle!
    var backgroundAnimator: AnimatorBackground!

    var tapAnywhereIsVisible = false
    
    var tapMovesForward = true
    
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
        
        setupAnimators()
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
