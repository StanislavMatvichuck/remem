//
//  ControllerOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class ControllerOnboardingOverlay: UIViewController {
    //

    // MARK: - Related types
    
    //
    
    enum Step: Int, CaseIterable {
        case showBackground
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
        case showTextAfterFirstSwipe
        case waitForSwipe02
        case showTextAfterSecondSwipe
        case waitForSwipe03
    }

    //

    // MARK: - Static properties

    //
    
    static let standartDuration = TimeInterval(0.3)
    
    //

    // MARK: - Public properties

    //
    
    weak var mainDataSource: ControllerMainOnboardingDataSource!
    
    weak var mainDelegate: ControllerMainOnboardingDelegate!
    
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate lazy var animationsHelper = AnimatorOnboarding(root: viewRoot, circle: viewRoot.viewCircle, finger: viewRoot.viewFinger)
    
    fileprivate let viewRoot = ViewOnboardingOverlay()
    
    fileprivate var tapAnywhereIsShown = false
    
    fileprivate var tapMovesForward = true
    
    fileprivate var currentStep: Step = .showBackground {
        didSet { perform(step: currentStep) }
    }
    
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
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    override func loadView() {
        view = viewRoot
    }
    
    override func viewDidLoad() {
        setupEventHandlers()
    }
    
    //

    // MARK: - Events handling

    //
    
    private func setupEventHandlers() {
        viewRoot.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        viewRoot.labelClose.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handlePressClose)))
        
        viewRoot.labelClose.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        if tapMovesForward { goToNextStep() }
    }
    
    @objc private func handlePressClose() {
        if let onboardingController = parent as? ControllerOnboardingContainer {
            onboardingController.closeOnboarding()
        }
    }
    
    //

    // MARK: - Behaviour

    //
    
    func start() {
        currentStep = .showBackground
    }
    
    func close(completionBlock: @escaping () -> Void) {
        animationsHelper.animatorBackground.hide()
        
        animationsHelper.animate(closeButton: viewRoot.labelClose)
        
        UIView.animate(withDuration: ControllerOnboardingOverlay.standartDuration,
                       delay: ControllerOnboardingOverlay.standartDuration,
                       animations: {
                           self.viewRoot.alpha = 0
                       }, completion: { flag in
                           if flag { completionBlock() }
                       })
    }
    
    fileprivate func goToNextStep() {
        currentStep = Step(rawValue: currentStep.rawValue + 1)!
    }
    
    fileprivate func perform(step: Step) {
        switch step {
        case .showBackground:
            UIView.animate(withDuration: ControllerOnboardingOverlay.standartDuration, animations: {
                self.viewRoot.alpha = 1
            }, completion: { flag in
                if flag {
                    self.currentStep = .showTextGreeting
                }
            })
        case .showTextGreeting:
            animationsHelper.show(label: viewRoot.labelGreeting)
            animationsHelper.show(label: viewRoot.labelTapToProceed)
            animationsHelper.show(label: viewRoot.labelClose)
        case .showTextName:
            animationsHelper.show(label: viewRoot.labelMyNameIs)
            animationsHelper.hide(label: viewRoot.labelTapToProceed)
        case .showTextFirstQuestion:
            animationsHelper.show(label: viewRoot.labelQuestion01)
        case .showTextSecondQuestion:
            animationsHelper.show(label: viewRoot.labelQuestion02)
        case .showTextHint:
            animationsHelper.show(label: viewRoot.labelHint)
        case .showTextStartIsEasy:
            viewRoot.labelGreeting.text = " "
            animationsHelper.hide(label: viewRoot.labelMyNameIs)
            animationsHelper.hide(label: viewRoot.labelQuestion01)
            animationsHelper.hide(label: viewRoot.labelQuestion02)
            animationsHelper.hide(label: viewRoot.labelHint)
            
            animationsHelper.show(label: viewRoot.labelStart)
            currentStep = .highlightBottomSection
        case .highlightBottomSection:
            animationsHelper.animatorBackground.show(view: mainDataSource.viewSwiper, cornerRadius: 0, offset: 0)
            currentStep = .showFloatingCircleUp
        case .showFloatingCircleUp:
            setupCircleForSwipeUpDemonstration()
            animationsHelper.animatorCircle.startUp()
            currentStep = .waitForSwipeUp
        case .waitForSwipeUp:
            NotificationCenter.default.addObserver(
                self, selector: #selector(handleNotification),
                name: .ControllerMainAddItemTriggered, object: nil
            )
            
            tapMovesForward = false
            viewRoot.isTransparentForTouches = true
        case .showTextGiveEventAName:
            NotificationCenter.default.removeObserver(self, name: .ControllerMainAddItemTriggered, object: nil)
            
            animationsHelper.hide(label: viewRoot.labelStart)
            
            viewRoot.viewCircle.layer.removeAllAnimations()
            viewRoot.viewCircle.isHidden = true
            viewRoot.labelEventName.bottomAnchor.constraint(
                equalTo: viewRoot.safeAreaLayoutGuide.bottomAnchor,
                constant: mainDataSource.inputHeightOffset
            ).isActive = true
            
            animationsHelper.show(label: viewRoot.labelEventName)
            animationsHelper.animatorBackground.show(view: mainDataSource.viewInput, cornerRadius: .r1, offset: 0)
            
            currentStep = .waitForEventSubmit
        case .waitForEventSubmit:
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainItemCreated, object: nil)
        case .highlightCreatedEntry:
            animationsHelper.hide(label: viewRoot.labelEventName)
            animationsHelper.animatorBackground.hide()

//        case showTextEntryDescription
//        case showTextTrySwipe
//        case showFloatingCircleRight
//        case waitForSwipe
//        case showTextAfterFirstSwipe
//        case waitForSwipe02
//        case showTextAfterSecondSwipe
//        case waitForSwipe03
        default:
            fatalError("⚠️ unhandled onboarding case")
        }
    }
    
    fileprivate func setupCircleForSwipeUpDemonstration() {
        let circleVerticalConstraint = viewRoot.viewCircle.centerYAnchor.constraint(
            equalTo: viewRoot.centerYAnchor,
            constant: AnimatorCircle.verticalTravelDistance / 2
        )

        circleVerticalConstraint.identifier = "circle.center.y"
        circleVerticalConstraint.isActive = true
        
        viewRoot.viewCircle.isHidden = false
        viewRoot.viewFinger.isHidden = false
        viewRoot.layoutIfNeeded()
    }
}

//

// MARK: - Notifications

//

extension ControllerOnboardingOverlay {
    @objc private func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .ControllerMainAddItemTriggered:
            currentStep = .showTextGiveEventAName
        default:
            return
        }
    }
}

extension Notification.Name {
    static let ControllerMainAddItemTriggered = Notification.Name(rawValue: "ControllerMainAddItemTriggered")
    static let ControllerMainItemCreated = Notification.Name(rawValue: "ControllerMainItemCreated")
}
