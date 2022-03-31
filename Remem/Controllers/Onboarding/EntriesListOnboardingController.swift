//
//  ControllerOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

protocol ControllerMainOnboardingDataSource: UIViewController {
    var viewSwiper: UIView { get }
    var viewInput: UIView { get }
    var inputHeightOffset: CGFloat { get }
}

protocol ControllerMainOnboardingDelegate: UIViewController {
    func createTestItem()
    func disableSettingsButton()
    func enableSettingsButton()
}

class EntriesListOnboardingController: UIViewController {
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
        case showTextAfterSwipe01
        case showTextAfterSwipe02
        case showTextAfterSwipe03
        case showTextAfterSwipe04
        case showTextAfterSwipe05
        case highlightTestItem
        case showTextCreatedTestItem
        case showTextLongPress
        case highlightLongPress
        case waitForLongPress
        case highlightViewList
        case waitForViewListPress
        case highlightPointsList
        case showTextPointsList
        case showTextScrollPoints
        case showFloatingCircleScrollPoints
        case waitForScrollPoints
        case highlightStats
        case showTextStatsDescription
        case showTextStatsScroll
        case showFloatingCircleScrollStats
        case waitForScrollStats
        case highlightDisplay
        case showTextDisplayDescription
        case showTextDisplayScroll
        case showFloatingCircleDisplayScroll
        case waitForDisplayScroll
        case showTextFinal
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
    
    fileprivate lazy var animationsHelper = AnimatorOnboarding(root: viewRoot,
                                                               circle: viewRoot.viewCircle,
                                                               finger: viewRoot.viewFinger,
                                                               background: viewRoot.viewBackground)
    
    fileprivate let viewRoot = EntriesListOnboardingView()
    
    fileprivate var tapAnywhereIsShown = false
    
    fileprivate var tapMovesForward = true
    
    fileprivate var currentStep: Step = .showBackground {
        didSet { perform(step: currentStep) }
    }
    
    fileprivate lazy var labelNameBottomConstraint: NSLayoutConstraint = {
        viewRoot.labelEventName.bottomAnchor.constraint(
            equalTo: viewRoot.bottomAnchor,
            constant: mainDataSource.inputHeightOffset)
    }()
    
    // TODO: maybe do it in a better way?
    /// for now notifications are used to pass these `uiView` objects
    fileprivate weak var cellToHighlight: UITableViewCell!
    fileprivate weak var viewToHighlight: UIView!
    
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
        finish()
    }
    
    //

    // MARK: - Behaviour

    //
    
    func start() {
        currentStep = .showBackground
        
        mainDelegate.disableSettingsButton()
    }
    
    func finish() {
        NotificationCenter.default.removeObserver(self)
        mainDelegate.enableSettingsButton()
        dismiss(animated: true)
    }
    
    fileprivate func goToNextStep() {
        currentStep = Step(rawValue: currentStep.rawValue + 1)!
    }
    
    fileprivate func perform(step: Step) {
        switch step {
        case .showBackground:
            UIView.animate(withDuration: EntriesListOnboardingController.standartDuration, animations: {
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
            animationsHelper.animatorCircle.start(.addItem)
            currentStep = .waitForSwipeUp
        case .waitForSwipeUp:
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainAddItemTriggered, object: nil)
            
            tapMovesForward = false
            viewRoot.isTransparentForTouches = true
        case .showTextGiveEventAName:
            NotificationCenter.default.removeObserver(self, name: .ControllerMainAddItemTriggered, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainInputConstraintUpdated, object: nil)
            
            viewRoot.isTransparentForTouches = false
            
            animationsHelper.hide(label: viewRoot.labelStart)
            
            animationsHelper.animatorCircle.stop()
            
            labelNameBottomConstraint.isActive = true
            
            animationsHelper.show(label: viewRoot.labelEventName)
            animationsHelper.animatorBackground.show(view: mainDataSource.viewInput, cornerRadius: .r1, offset: 0)
            
            currentStep = .waitForEventSubmit
        case .waitForEventSubmit:
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainItemCreated, object: nil)
        case .highlightCreatedEntry:
            NotificationCenter.default.removeObserver(self, name: .ControllerMainItemCreated, object: nil)
            NotificationCenter.default.removeObserver(self, name: .ControllerMainInputConstraintUpdated, object: nil)
            
            viewRoot.labelEventName.isHidden = true
            animationsHelper.animatorBackground.hide()
            animationsHelper.animatorBackground.show(view: cellToHighlight)
            tapMovesForward = true
            currentStep = .showTextEntryDescription
        case .showTextEntryDescription:
            animationsHelper.show(label: viewRoot.labelEventCreated)
        case .showTextTrySwipe:
            animationsHelper.show(label: viewRoot.labelEventSwipe)
            tapMovesForward = false
            currentStep = .showFloatingCircleRight
        case .showFloatingCircleRight:
            animationsHelper.animatorCircle.start(.addPoint)
            currentStep = .waitForSwipe
        case .waitForSwipe:
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainItemSwipe, object: nil)
            
            viewRoot.isTransparentForTouches = true
        case .showTextAfterSwipe01:
            animationsHelper.animatorCircle.stop()
            
            animationsHelper.show(label: viewRoot.labelSwipeComplete)
        case .showTextAfterSwipe02:
            animationsHelper.show(label: viewRoot.labelAdditionalSwipes)
        case .showTextAfterSwipe03:
            viewRoot.labelAdditionalSwipes.text = "3 / 5"
        case .showTextAfterSwipe04:
            viewRoot.labelAdditionalSwipes.text = "4 / 5"
        case .showTextAfterSwipe05:
            viewRoot.labelAdditionalSwipes.text = "5 / 5"
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainItemCreated, object: nil)
            
            mainDelegate.createTestItem()
            
            tapMovesForward = false
            
            NotificationCenter.default.removeObserver(self, name: .ControllerMainItemSwipe, object: nil)
        case .highlightTestItem:
            NotificationCenter.default.removeObserver(self, name: .ControllerMainItemCreated, object: nil)
            animationsHelper.animatorBackground.show(view: cellToHighlight)
            currentStep = .showTextCreatedTestItem
        case .showTextCreatedTestItem:
            animationsHelper.hide(label: viewRoot.labelEventCreated)
            animationsHelper.hide(label: viewRoot.labelEventSwipe)
            animationsHelper.hide(label: viewRoot.labelAdditionalSwipes)
            animationsHelper.hide(label: viewRoot.labelSwipeComplete)
            
            animationsHelper.show(label: viewRoot.labelTestItemDescription)
            tapMovesForward = true
            viewRoot.isTransparentForTouches = false
        case .showTextLongPress:
            animationsHelper.show(label: viewRoot.labelTestItemLongPress)
            currentStep = .highlightLongPress
        case .highlightLongPress:
            if let cellMain = cellToHighlight as? EntryCell {
                animationsHelper.animatorBackground.move(to: cellMain.viewMovable)
            }
            currentStep = .waitForLongPress
        case .waitForLongPress:
            tapMovesForward = false
            viewRoot.isTransparentForTouches = true
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification),
                                                   name: .ControllerMainPresentedDetails, object: nil)
        case .highlightViewList:
            NotificationCenter.default.removeObserver(self, name: .ControllerMainPresentedDetails, object: nil)
            animationsHelper.animatorBackground.show(view: viewToHighlight)
        default:
            fatalError("⚠️ unhandled onboarding case")
        }
    }
}

//

// MARK: - Notifications

//

extension EntriesListOnboardingController {
    @objc private func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .ControllerMainAddItemTriggered:
            currentStep = .showTextGiveEventAName
        case .ControllerMainItemCreated:
            guard let cell = notification.object as? UITableViewCell else { return }
            cellToHighlight = cell
            
            if currentStep == .showTextAfterSwipe05 {
                currentStep = .highlightTestItem
            } else {
                currentStep = .highlightCreatedEntry
            }
        case .ControllerMainInputConstraintUpdated:
            guard mainDataSource.inputHeightOffset != -.delta1 else { return }
            /// this guard statement fixes immediate label disappearing
            UIView.animate(withDuration: EntriesListOnboardingController.standartDuration, delay: 0, options: .curveEaseInOut, animations: {
                self.labelNameBottomConstraint.constant = self.mainDataSource.inputHeightOffset
                self.viewRoot.layoutIfNeeded()
            }, completion: nil)
            animationsHelper.animatorBackground.move(to: mainDataSource.viewInput, cornerRadius: .r1)
        case .ControllerMainItemSwipe:
            goToNextStep()
        case .ControllerMainPresentedDetails:
            guard let view = notification.object as? UIView else { return }
            viewToHighlight = view
            currentStep = .highlightViewList
        default:
            fatalError("Unhandled notification")
        }
    }
}

extension Notification.Name {
    static let ControllerMainAddItemTriggered = Notification.Name(rawValue: "ControllerMainAddItemTriggered")
    static let ControllerMainItemCreated = Notification.Name(rawValue: "ControllerMainItemCreated")
    static let ControllerMainInputConstraintUpdated = Notification.Name(rawValue: "ControllerMainInputConstraintUpdated")
    static let ControllerMainItemSwipe = Notification.Name(rawValue: "ControllerMainItemSwipe")
    static let ControllerMainPresentedDetails = Notification.Name(rawValue: "ControllerMainPresentedDetails")
}
