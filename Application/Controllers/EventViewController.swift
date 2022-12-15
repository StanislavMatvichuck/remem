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
    let viewRoot: EventView
    var viewModel: EventViewModel

    // MARK: - Init
    init(viewModel: EventViewModel, controllers: [UIViewController]) {
        self.viewModel = viewModel
        self.viewRoot = EventView()

        super.init(nibName: nil, bundle: nil)

        for controller in controllers { contain(controller: controller) }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.visit()
    }

    private func contain(controller: UIViewController) {
        addChild(controller)
        viewRoot.scroll.viewContent.addArrangedSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
