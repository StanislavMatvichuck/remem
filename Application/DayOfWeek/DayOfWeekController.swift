//
//  DayOfWeekController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 25.01.2024.
//

import Foundation
import UIKit

final class DayOfWeekController: UIViewController {
    private let viewRoot = DayOfWeekView()
    let factory: DayOfWeekViewModelFactoring

    var viewModel: DayOfWeekViewModel? { didSet {
        guard let viewModel else { return }
        viewRoot.viewModel = viewModel
    }}

    // MARK: - Init
    init(_ factory: DayOfWeekViewModelFactoring) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = factory.makeDayOfWeekViewModel()
    }
}
