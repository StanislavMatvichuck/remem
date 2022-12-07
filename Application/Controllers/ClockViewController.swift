//
//  ClockViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import IosUseCases
import UIKit

class ClockViewController: UIViewController {
    let viewRoot: ClockView
    let sorter: ClockStrategy
    var viewModel: ClockViewModel
    var event: Event

    init(event: Event, useCase: EventEditUseCasing, sorter: ClockStrategy) {
        self.event = event
        self.sorter = sorter
        self.viewModel = ClockViewModel(happenings: event.happenings, sorter: sorter)
        self.viewRoot = ClockView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        useCase.add(delegate: self)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {}

    private func update() {
        guard
            let layers = viewRoot.clockFace.layer.sublayers as? [ClockLayer]
        else { return }

        viewModel.sections.enumerated().forEach { index, section in
            layers[index].viewModel = section
        }
    }
}

extension ClockViewController: EventEditUseCasingDelegate {
    func update(event: Domain.Event) {
        guard self.event == event else { return }

        viewModel = ClockViewModel(happenings: event.happenings, sorter: sorter)
        update()
    }
}
