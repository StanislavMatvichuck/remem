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
    
    static let standartDuration = TimeInterval(0.5)
    
    //

    // MARK: - Public properties

    //
    
    weak var mainDataSource: ControllerMainOnboardingDataSource!
    
    weak var mainDelegate: ControllerMainOnboardingDelegate!
    
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate lazy var animationsHelper = AnimationsHelperOnboarding(background: viewRoot, delegate: self)
    
    let viewRoot = ViewOnboardingOverlay()
    
    fileprivate var tapAnywhereIsShown = false
    
    fileprivate var tapMovesForward = true
    
    fileprivate var currentStep: Step = .showBackground {
        didSet {
            print("newCurrentStep is \(currentStep)")
            perform(step: currentStep)
        }
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
            UITapGestureRecognizer(target: self, action: #selector(handleTap))
        )
        
        viewRoot.labelClose.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handlePressClose))
        )
        
        viewRoot.labelClose.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap() {
        if tapMovesForward {
            goToNextStep()
        }
    }
    
    @objc private func handlePressClose() {
        guard let onboardingController = parent as? ControllerOnboardingContainer else { return }
        onboardingController.closeOnboarding()
    }
    
    //

    // MARK: - Behaviour

    //
    
    func start() {
        currentStep = .showBackground
    }
    
    func close(completionBlock: @escaping () -> Void) {
        animationsHelper.addAnimationToMaskLayer(willShowHighlight: false)
        
        UIView.animate(withDuration: 0.3, delay: ControllerOnboardingOverlay.standartDuration, animations: {
            self.viewRoot.alpha = 0
        }, completion: { flag in
            guard flag else { return }
            completionBlock()
        })
    }
    
    fileprivate func goToNextStep() {
        currentStep = Step(rawValue: currentStep.rawValue + 1)!
    }
    
    fileprivate func perform(step: Step) {
        switch step {
        case .showBackground:
            UIView.animate(withDuration: 0.3, animations: {
                self.viewRoot.alpha = 1
            }, completion: { flag in
                guard flag else { return }
                self.currentStep = .showTextGreeting
            })
        case .showTextGreeting:
            animate(label: viewRoot.labelGreeting)
            animate(label: viewRoot.labelTapToProceed)
        case .showTextName:
            animate(label: viewRoot.labelMyNameIs)
            removeWithAnimation(label: viewRoot.labelTapToProceed)
        case .showTextFirstQuestion:
            animate(label: viewRoot.labelQuestion01)
        case .showTextSecondQuestion:
            animate(label: viewRoot.labelQuestion02)
        case .showTextHint:
            animate(label: viewRoot.labelHint)
            animate(label: viewRoot.labelClose)
        case .showTextStartIsEasy:
            animate(label: viewRoot.labelStart)
            currentStep = .highlightBottomSection
        case .highlightBottomSection:
            animationsHelper.animateMaskLayer(for: mainDataSource.viewSwiper, cornerRadius: 0, offset: 0)
            currentStep = .showFloatingCircleUp
        case .showFloatingCircleUp:
            animateCircle(with: AnimationsHelperOnboarding.OnboardingSwipeAnimationVariants.bottomTop)
            currentStep = .waitForSwipeUp
        case .waitForSwipeUp:
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainAddItemTriggered, object: nil)
            viewRoot.isTransparentForTouches = true
            tapMovesForward = false
        case .showTextGiveEventAName:
            NotificationCenter.default.removeObserver(self, name: .ControllerMainAddItemTriggered, object: nil)
            
            removeWithAnimation(label: viewRoot.labelGreeting)
            removeWithAnimation(label: viewRoot.labelMyNameIs)
            removeWithAnimation(label: viewRoot.labelQuestion01)
            removeWithAnimation(label: viewRoot.labelQuestion02)
            removeWithAnimation(label: viewRoot.labelHint)
            removeWithAnimation(label: viewRoot.labelStart)
            
            viewRoot.viewCircle.layer.removeAllAnimations()
            viewRoot.viewCircle.isHidden = true
            viewRoot.labelEventName.bottomAnchor.constraint(
                equalTo: viewRoot.safeAreaLayoutGuide.bottomAnchor,
                constant: mainDataSource.inputHeightOffset
            ).isActive = true
            
            animate(label: viewRoot.labelEventName)
            animationsHelper.animateMaskLayer(for: mainDataSource.viewInput, cornerRadius: .r1, offset: 0)
            
            currentStep = .waitForEventSubmit
        case .waitForEventSubmit:
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainItemCreated, object: nil)
            
        case .highlightCreatedEntry:
            removeWithAnimation(label: viewRoot.labelEventName)
            animationsHelper.addAnimationToMaskLayer(willShowHighlight: false)
            animationsHelper.animateMaskLayer(for: mainDataSource.viewCellCreated, cornerRadius: .r1, offset: 0)

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
    
    //

    // MARK: Text animaiton

    //
    
    private func animate(label: UILabel) {
        label.isHidden = false
        viewRoot.layoutIfNeeded()
        
        let appearAnimation = animationsHelper.createAppearAnimation(for: label)
        label.layer.add(appearAnimation, forKey: nil)
    }
    
    private func removeWithAnimation(label: UILabel) {
        let removeAnimation = animationsHelper.createDisappearAnimation(for: label)

        label.layer.add(removeAnimation, forKey: nil)
        label.layer.position.y = label.layer.position.y + 30
        label.layer.opacity = 0
    }
    
    //

    // MARK: Circle animation

    //
    
    private func animateCircle(with direction: AnimationsHelperOnboarding.OnboardingSwipeAnimationVariants) {
        viewRoot.viewCircle.isHidden = false
        viewRoot.layoutIfNeeded()
        
        switch direction {
        case .bottomTop:
            let circleSwipeAnimation = animationsHelper.createSwipeUpAnimation(for: viewRoot.viewCircle)
            viewRoot.viewCircle.layer.add(circleSwipeAnimation, forKey: nil)
        case .leftRight:
            return
        }
    }
}

//

// MARK: - CAAnimationDelegate

//

extension ControllerOnboardingOverlay: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard
            let name = anim.value(forKey: AnimationsHelperOnboarding.OnboardingCodingKeys.animationName.rawValue)
            as? AnimationsHelperOnboarding.OnboardingAnimationsNames,
            flag else { return }

        switch name {
        case .circleSwipeUp:
            print("swiped up")
        case .labelDisappear:
            guard
                let label = anim.value(forKey: AnimationsHelperOnboarding.OnboardingCodingKeys.labelToBeRemoved.rawValue)
                as? UILabel else { return }
            label.isHidden = true
        }
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
