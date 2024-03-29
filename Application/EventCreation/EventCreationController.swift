//
//  EventCreationController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

import UIKit

final class EventCreationController: UIViewController, UITextFieldDelegate {
    // MARK: - Properties
    private let factory: EventCreationViewModelFactoring
    private let viewRoot = EventCreationView()
    private var viewModel: EventCreationViewModel? { didSet {
        viewRoot.viewModel = viewModel
    }}
    private let submitService: CreateEventService

    // MARK: - Init
    init(_ factory: EventCreationViewModelFactoring, submitService: CreateEventService) {
        self.factory = factory
        self.submitService = submitService
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = factory.makeEventCreationViewModel()
        configureEventHandlers()
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewRoot.input.becomeFirstResponder()
    }

    private func configureEventHandlers() {
        viewRoot.input.delegate = self

        viewRoot.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))

        viewRoot.emojiButtons.forEach { $0.addTarget(self, action: #selector(handleEmojiTap), for: .touchUpInside) }

        NotificationCenter.default.addObserver(
            self, selector: #selector(handleTextField),
            name: UITextField.textDidChangeNotification, object: nil
        )
    }

    @objc private func handleTap() { dismiss(animated: true) }
    @objc private func handleEmojiTap(sender: UIButton) { viewModel?.handle(emoji: sender.tag) }
    @objc private func handleTextField() { viewModel?.createdEventName = viewRoot.input.text! }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = viewModel?.createdEventName {
            submitService.serve(CreateEventServiceArgument(name: name))
        }
        dismiss(animated: true)
        return true
    }
}
