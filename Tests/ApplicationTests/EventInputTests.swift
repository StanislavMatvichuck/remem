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

    func test_init() {
        XCTAssertNotNil(sut)
    }

    func test_installedToControllerRootView() {
        XCTAssertNotNil(sut.superview)
        XCTAssertFalse(sut.isUserInteractionEnabled, "must not cover screen initially")
    }

    func test_backgroundInitiallyNotVisible() {
        XCTAssertTrue(sut.background.isHidden)
    }

    func test_hasHintLabel() {
        let hintText = sut.namingHintLabel.text ?? ""

        XCTAssertEqual(hintText, String(localizationId: "eventsList.new"))
    }

    func test_hasEmojisInHorizontalStackInScrollView() {
        let emojis = emojis()

        XCTAssertEqual(emojis.count, 9)
    }

    func test_hasBlurredBackground() {
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

    func test_hasInputAccessories() {
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

    func test_show_empty() {
        sut.show(value: "")

        XCTAssertEqual(sut.textField.text, "", "text must match show argument")
        XCTAssertFalse(sut.background.isHidden, "background is immediately visible")
        XCTAssertTrue(sut.textField.isFirstResponder, "input must show keyboard")
        XCTAssertTrue(sut.isUserInteractionEnabled, "must receive touches")
    }

    func test_show_canBeCancelled() {
        sut.show(value: "")
        XCTAssertTrue(sut.textField.isFirstResponder, "precondition")

        tap(sut.barCancel)

        XCTAssertFalse(sut.textField.isFirstResponder, "keyboard must hide")
        XCTAssertTrue(sut.background.isHidden, "background hides immediately")
        XCTAssertFalse(sut.isUserInteractionEnabled, "must be transparent for touches")
    }

    func test_show_emojiTapped_addsItToTextfield() {
        sut.show(value: "")
        guard let emoji = emojis().first else {
            XCTFail("must be at least one tappable emoji")
            return
        }

        tap(emoji)

        XCTAssertEqual(sut.value, emoji.titleLabel?.text)
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
}
