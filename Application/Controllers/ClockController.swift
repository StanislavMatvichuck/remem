//
//  ClockController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import IosUseCases
import UIKit

class ClockController: UIViewController {
    let viewRoot: ClockView
    var viewModel: ClockViewModel
    var event: Event

    init(event: Event, useCase: EventEditUseCasing) {
        self.event = event
        self.viewModel = ClockViewModel(happenings: event.happenings)
        self.viewRoot = ClockView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        useCase.add(delegate: self)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {}
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }

    /// bullshit method. too much details about view and viewModel
    private func update() {
        for i in 0 ... ClockViewModel.size - 1 {
            guard
                let layers = viewRoot.clockFace.layer.sublayers as? [ClockSectionAnimatedLayer],
                let section = viewModel.section(at: i)
            else { continue }

            layers[i].animate(at: i, to: section)
        }
    }
}

extension ClockController: EventEditUseCasingDelegate {
    func update(event: Domain.Event) {
        guard self.event == event else { return }

        viewModel = ClockViewModel(happenings: event.happenings)
        update()
    }
}
