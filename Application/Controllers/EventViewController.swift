//
//  ControllerList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import Domain

import UIKit

class EventViewController: UIViewController {
    // MARK: - Properties
    let viewRoot = EventView()
    let commander: EventsCommanding
    var event: Event
    var viewModel: EventViewModel

    // MARK: - Init
    init(
        event: Event,
        commander: EventsCommanding,
        controllers: [UIViewController]
    ) {
        self.event = event
        self.viewModel = EventViewModel(event: event)
        self.commander = commander

        super.init(nibName: nil, bundle: nil)

        title = viewModel.title

        for controller in controllers {
            contain(controller: controller)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        event.visit()
        commander.save(event)
    }

    private func contain(controller: UIViewController) {
        addChild(controller)
        viewRoot.scroll.viewContent.addArrangedSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
