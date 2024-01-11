//
//  EventInputTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 04.11.2022.
//

@testable import Application
import XCTest

class EventInputTests: XCTestCase {
    var sut: EventInputView!

    override func setUp() {
        super.setUp()

        let controller = UIViewController()
        controller.loadViewIfNeeded()
        putInViewHierarchy(controller)

        let sut = EventInputView()
        self.sut = sut

        controller.view.addSubview(sut)
    }

    override func tearDown() {
        sut = nil
        executeRunLoop()
        super.tearDown()
    }

    func test_addedAsSubview() {
        XCTAssertNotNil(sut.superview)
    }

    func test_addedAsSubview_shouldNotReceiveTouches() {
        XCTAssertFalse(sut.isUserInteractionEnabled, "must not cover screen initially")
    }

    func test_addedAsSubview_backgroundIsNotCoveringScreen() {
        XCTAssertTrue(sut.background.isHidden, "background initially hidden")
    }

    func test_showsHint() {
        XCTAssertEqual(
            sut.background.hint.text,
            String(localizationId: "eventsList.new")
        )
    }

    func test_shows_9emojis() {
        XCTAssertEqual(emojis().count, 9)
    }

    func test_shows_blurredBackground() {
        guard let background = sut.background.subviews.first as? UIVisualEffectView else {
            XCTFail("no blur for background")
            return
        }

        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)

        XCTAssertEqual(background.effect, blurEffect)
        XCTAssertEqual(
            sut.background.gestureRecognizers?.count, 1,
            "background must be tappable"
        )
    }

    func test_shows_textField() {
        XCTAssertNotNil(sut.inputContainer.field.delegate, "textField delegate must be set")
    }

    func test_show_backgroundCoversScreen() {
        sut.show(value: "")

        XCTAssertFalse(sut.background.isHidden)
    }

    func test_show_shouldReceiveTouches() {
        sut.show(value: "")

        XCTAssertTrue(sut.isUserInteractionEnabled)
    }

    func test_show_keyboardShouldAppear() {
        XCTAssertFalse(sut.inputContainer.field.isFirstResponder, "precondition")

        sut.show(value: "")

        XCTAssertTrue(sut.inputContainer.field.isFirstResponder)
    }

    func test_show_backgroundIsNotHidden() {
        XCTAssertTrue(sut.background.isHidden, "precondition")

        sut.show(value: "")

        XCTAssertFalse(sut.background.isHidden)
    }

    func test_show_backgroundIsTransparent() {
        sut.show(value: "")

        XCTAssertEqual(sut.background.alpha, 0)
    }

    func test_show_blurBackgroundAndMoveInputWithKeyboardAnimation() {
        arrange_afterShowAnimation()

        assert_inputIsShown()
        XCTAssertEqual(
            sut.background.alpha, 1,
            "background is opaque after animation"
        )
        XCTAssertNotEqual(
            sut.constraint.constant, 0,
            "must use keyboard height"
        )
    }

    func test_hide_dissolveBackgroundAndMoveInputWithKeyboardAnimation() {
        arrange_afterShowAndHideAnimation()

        assert_inputIsHidden()
        XCTAssertEqual(
            sut.background.alpha, 0,
            "background is transparent after animation"
        )
        XCTAssertEqual(
            sut.constraint.constant, 0,
            "everything must be hidden under screen"
        )
    }

    func test_whenShown_tappingEmoji_addsEmojiToTextfield() {
        sut.show(value: "")

        guard let emoji = emojis().first else {
            XCTFail("must be at least one tappable emoji")
            return
        }

        tap(emoji)

        XCTAssertEqual(sut.value, emoji.titleLabel?.text)
    }

    func test_whenShown_tappingKeyboardReturn_shouldSubmit() {
        sut.show(value: "BOGUS")

        assert_inputIsShown(value: "BOGUS")

        _ = sut.inputContainer.field.delegate?.textFieldShouldReturn?(sut.inputContainer.field)

        assert_inputIsHidden()
    }

    func test_gettingValue_returnsTextFieldText() {
        sut.inputContainer.field.text = "BOGUS"

        XCTAssertEqual(sut.value, "BOGUS")
    }
}

// MARK: - Private
private extension EventInputTests {
    func emojis(
        file: StaticString = #file,
        line: UInt = #line
    ) -> [UIButton] {
        guard let container = sut.emojiContainer.subviews.first as? UIStackView else {
            XCTFail("emojis container must be a stack", file: file, line: line)
            return []
        }

        XCTAssertEqual(container.axis, .horizontal,
                       "axis must be horizontal",
                       file: file, line: line)

        var result = [UIButton]()

        for emoji in container.subviews {
            do {
                let button = try XCTUnwrap(emoji as? UIButton)
                result.append(button)
            } catch {
                XCTFail("emoji must be a tappable button")
            }
        }

        return result
    }

    func assert_inputIsHidden(
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertFalse(
            sut.inputContainer.field.isFirstResponder,
            "keyboard must hide",
            file: file, line: line
        )
        // that has an influence on first responder
        XCTAssertFalse(
            sut.isUserInteractionEnabled,
            "must be transparent for touches",
            file: file, line: line
        )
        XCTAssertEqual(
            sut.value, "",
            "text field text must be empty",
            file: file, line: line
        )
    }

    func assert_inputIsShown(
        value: String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(
            sut.inputContainer.field.text, value,
            "text must match show argument",
            file: file, line: line
        )
        XCTAssertFalse(
            sut.background.isHidden,
            "background is immediately visible",
            file: file, line: line
        )
        XCTAssertTrue(
            sut.inputContainer.field.isFirstResponder,
            "input must show keyboard",
            file: file, line: line
        )
        // that has an influence on first responder
        XCTAssertTrue(
            sut.isUserInteractionEnabled,
            "must receive touches",
            file: file, line: line
        )
    }

    func assert(thatButton: UIBarButtonItem, sendsActionsFor: UIControl.Event) {
        let exp = XCTestExpectation(description: "action must be sent by sut")
        let spy = ActionSpy(exp)
        sut.addTarget(spy, action: #selector(ActionSpy.catchAction), for: sendsActionsFor)

        sut.show(value: "SomeValue")

        tap(thatButton)

        wait(for: [exp], timeout: 0.1)
    }

    func arrange_afterShowAnimation() {
        let exp = XCTestExpectation(description: "background updated asynchronously")
        sut.animationCompletionHandler = { exp.fulfill() }

        sut.show(value: "")

        // simulating UIResponder notification dispatch
        DispatchQueue.main.async {
            self.sut.animateShowingKeyboard(
                notification: self.makeKeyboardNotificationFake()
            )
        }

        wait(for: [exp], timeout: 0.1)
    }

    func arrange_afterShowAndHideAnimation() {
        arrange_afterShowAnimation()

        let exp = XCTestExpectation(description: "background disappears asynchronously")
        sut.animationCompletionHandler = { exp.fulfill() }

        sut.hide()

        // simulating UIResponder notification dispatch
        DispatchQueue.main.async {
            self.sut.animateHidingKeyboard(
                notification: self.makeKeyboardNotificationFake()
            )
        }

        wait(for: [exp], timeout: 0.1)
    }

    func makeKeyboardNotificationFake() -> NSNotification {
        let keyboardRect = CGRect(
            x: 0, y: 0,
            width: UIScreen.main.bounds.width,
            height: 300
        )

        return NSNotification(
            name: UIResponder.keyboardWillShowNotification,
            object: nil,
            userInfo: [
                UIResponder.keyboardFrameEndUserInfoKey: NSValue(cgRect: keyboardRect),
                UIResponder.keyboardAnimationDurationUserInfoKey: Double(0.1),
                UIResponder.keyboardAnimationCurveUserInfoKey: Int(0),
            ]
        )
    }
}

class ActionSpy {
    private var exp: XCTestExpectation
    init(_ exp: XCTestExpectation) {
        self.exp = exp
    }

    @objc func catchAction() {
        exp.fulfill()
    }
}
