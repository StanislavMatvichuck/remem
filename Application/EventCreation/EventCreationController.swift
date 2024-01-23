//
//  EventCreationController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 23.01.2024.
//

import Foundation

import UIKit

class EventCreationController: UIViewController {
    // MARK: - Properties
    private let viewRoot = EventCreationView()

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewRoot.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))
    }

    @objc private func handleTap() {
        dismiss(animated: true)
    }
}
