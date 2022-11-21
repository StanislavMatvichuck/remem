//
//  ClockController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import Domain
import UIKit

class ClockController: UIViewController {
    // MARK: - Properties
    let viewRoot = ClockView()
    var event: Event
    var viewModel: ClockViewModel
    // MARK: - Init
    init(event: Event) {
        self.event = event
        self.viewModel = ClockViewModel(event: event)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {}
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }

    private func update() {
        for i in 0 ... ClockSectionsList.size - 1 {
            guard
                let layers = viewRoot.clock.clockFace.layer.sublayers as? [ClockSectionAnimatedLayer],
                let section = viewModel.section(at: i)
            else { continue }

            layers[i].animate(at: i, to: section)
        }
    }
}
