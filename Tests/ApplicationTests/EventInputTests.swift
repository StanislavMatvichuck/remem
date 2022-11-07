//
//  EventInputTests.swift
//  ApplicationTests
//
//  Created by Stanislav Matvichuck on 04.11.2022.
//

@testable import Application
import XCTest

class EventInputTests: XCTestCase {
    private var sut: EventInput!

    override func setUp() {
        super.setUp()

        let controller = UIViewController()
        controller.loadViewIfNeeded()
        putInViewHierarchy(controller)

        sut = EventInput()

        controller.view.addSubview(sut)
    }

    override func tearDown() {
        executeRunLoop()
        sut = nil
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

    func test_displays_hintLabel() {
        XCTAssertEqual(
            sut.namingHintLabel.text,
            String(localizationId: "eventsList.new")
        )
    }

    func test_displays_9emojis() {
        XCTAssertEqual(emojis().count, 9)
    }

    func test_displays_blurredBackground() {
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

    func test_displays_textField() {
        XCTAssertNotNil(sut.textField.delegate, "textField delegate must be set")
    }

    func test_displays_keyboardToolbar() {
        let cancel = sut.barCancel
        let submit = sut.barSubmit
        let input = sut.textField

        guard let bar = input.inputAccessoryView as? UIToolbar else {
            XCTFail("input must have a toolbar")
            return
        }

        XCTAssertEqual(bar.items?[0], cancel, "no cancel accessory button")
        XCTAssertEqual(bar.items?[2], submit, "no submit accessory button")

        XCTAssertEqual(
            bar.items?[0].title, String(localizationId: "button.cancel"),
            "cancel button text mismatch"
        )

        XCTAssertEqual(
            bar.items?[2].title, String(localizationId: "button.create"),
            "submit button text mismatch"
        )
    }

    func test_show_backgroundCoversScreen() {
        sut.show()

        XCTAssertFalse(sut.background.isHidden)
    }

    func test_show_shouldReceiveTouches() {
        sut.show()

        XCTAssertTrue(sut.isUserInteractionEnabled)
    }

    func test_show_keyboardShouldAppear() {
        XCTAssertFalse(sut.textField.isFirstResponder, "precondition")

        sut.show()

        XCTAssertTrue(sut.textField.isFirstResponder)
    }

    func test_whenShown_tappingEmoji_addsEmojiToTextfield() {
        sut.show()

        guard let emoji = emojis().first else {
            XCTFail("must be at least one tappable emoji")
            return
        }

        tap(emoji)

        XCTAssertEqual(sut.value, emoji.titleLabel?.text)
    }

    func test_whenShown_tappingCancel_hidesInput() {
        sut.show(value: "")
        XCTAssertTrue(sut.textField.isFirstResponder, "precondition")

        tap(sut.barCancel)

        assertInputIsHidden()
    }

    func test_whenShown_tappingSubmit_hidesInput() {
        sut.show(value: "")
        XCTAssertTrue(sut.textField.isFirstResponder, "precondition")

        tap(sut.barSubmit)

        assertInputIsHidden()
    }

    func test_whenShown_tappingKeyboardReturn_shouldSubmit() {
        sut.show(value: "BOGUS")

        assertInputIsShown(value: "BOGUS")

        _ = sut.textField.delegate?.textFieldShouldReturn?(sut.textField)

        assertInputIsHidden()
    }

    func test_settingValue_empty_submitDisabled() {
        sut.value = ""

        XCTAssertFalse(sut.barSubmit.isEnabled)
    }

    func test_settingValue_notEmpty_submitEnabled() {
        sut.value = "_"

        XCTAssertTrue(sut.barSubmit.isEnabled)
    }

    func test_gettingValue_returnsTextFieldText() {
        sut.textField.text = "BOGUS"

        XCTAssertEqual(sut.value, "BOGUS")
    }
}

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

    func assertInputIsHidden(
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertFalse(
            sut.textField.isFirstResponder,
            "keyboard must hide",
            file: file, line: line
        )
        XCTAssertTrue(
            sut.background.isHidden,
            "background hides immediately",
            file: file, line: line
        )
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

    func assertInputIsShown(
        value: String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) {
        XCTAssertEqual(
            sut.textField.text, value,
            "text must match show argument",
            file: file, line: line
        )
        XCTAssertFalse(
            sut.background.isHidden,
            "background is immediately visible",
            file: file, line: line
        )
        XCTAssertTrue(
            sut.textField.isFirstResponder,
            "input must show keyboard",
            file: file, line: line
        )
        XCTAssertTrue(
            sut.isUserInteractionEnabled,
            "must receive touches",
            file: file, line: line
        )
    }
}
