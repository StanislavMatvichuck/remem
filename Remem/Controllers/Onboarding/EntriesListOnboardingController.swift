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
    
    private lazy var animationsHelper = AnimatorOnboarding(root: viewRoot,
                                                           circle: viewRoot.viewCircle,
                                                           finger: viewRoot.viewFinger,
                                                           background: viewRoot.viewBackground)
    
    private let viewRoot = EntriesListOnboardingView()
    
    private var tapAnywhereIsShown = false
    
    private var tapMovesForward = true
    
    private var currentStep: Step = .showTextGreeting {
        didSet {
            print("switching to \(currentStep)")
            perform(step: currentStep)
        }
    }
    
    private lazy var labelNameBottomConstraint: NSLayoutConstraint = {
        viewRoot.labelEventName.bottomAnchor.constraint(
            equalTo: viewRoot.bottomAnchor,
            constant: 300)
    }()
    
    // TODO: maybe do it in a better way?
    /// for now notifications are used to pass these `uiView` objects
    private weak var cellToHighlight: UITableViewCell!
    private weak var viewToHighlight: UIView!
    
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
        perform(step: currentStep)
        mainDelegate.disableSettingsButton()
    }
    
    func finish() {
        NotificationCenter.default.removeObserver(self)
        mainDelegate.enableSettingsButton()
        dismiss(animated: true)
    }
    
    private func goToNextStep() {
        currentStep = Step(rawValue: currentStep.rawValue + 1)!
    }
    
    private func perform(step: Step) {
        switch step {
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
            watch(.UIMovableTextViewShown)
            tapMovesForward = false
            viewRoot.isTransparentForTouches = true
        case .showTextGiveEventAName:
            ignore(.UIMovableTextViewShown)
            watch(.UIMovableTextViewWillShow)
            viewRoot.isTransparentForTouches = false
            labelNameBottomConstraint.isActive = true
            
            animationsHelper.hide(label: viewRoot.labelStart)
            animationsHelper.animatorCircle.stop()
            animationsHelper.show(label: viewRoot.labelEventName)
            animationsHelper.animatorBackground.show(view: viewToHighlight, cornerRadius: .r1, offset: 0)
    
            currentStep = .waitForEventSubmit
        case .waitForEventSubmit:
            watch(.EntriesListNewEntry)
        case .highlightCreatedEntry:
            ignore(.UIMovableTextViewWillShow)
            ignore(.EntriesListNewEntry)
            
            viewRoot.labelEventName.isHidden = true
            tapMovesForward = true
            
            animationsHelper.animatorBackground.show(view: cellToHighlight)
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
            watch(.EntriesListNewPoint)
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
            watch(.EntriesListNewEntry)
            ignore(.EntriesListNewPoint)
            mainDelegate.createTestItem()
            tapMovesForward = false
        case .highlightTestItem:
            ignore(.EntriesListNewEntry)
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
            currentStep = .waitForEntryDetailsPresentationAttempt
        case .waitForEntryDetailsPresentationAttempt:
            tapMovesForward = false
            viewRoot.isTransparentForTouches = true
            watch(.EntriesListDetailsPresentationAttempt)
        default:
            fatalError("⚠️ unhandled onboarding case")
        }
    }
    
    private func watch(_ name: Notification.Name) {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: name, object: nil)
    }
    
    private func ignore(_ name: Notification.Name) {
        NotificationCenter.default.removeObserver(self, name: name, object: nil)
    }
}

//

// MARK: - Notifications

//

extension EntriesListOnboardingController {
    @objc private func handleNotification(_ notification: Notification) {
        switch notification.name {
        case .UIMovableTextViewShown:
            if let view = notification.object as? UIView {
                viewToHighlight = view
                currentStep = .showTextGiveEventAName
            }
        case .UIMovableTextViewWillShow:
            if let descriptor = notification.object as? UIMovableTextView.KeyboardHeightChangeDescriptor {
                animationsHelper.animatorBackground.moveShownArea(by: descriptor.movedBy, duration: descriptor.duration)
            }
        case .EntriesListNewEntry:
            guard let cell = notification.object as? UITableViewCell else { return }
            cellToHighlight = cell
            
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
                present(preparedEntryDetailsController, animated: true)
            }
        default:
            fatalError("Unhandled notification")
        }
    }
}
