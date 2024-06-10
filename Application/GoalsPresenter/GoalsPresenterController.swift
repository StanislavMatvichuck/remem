//
//  GoalsPresenterController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 10.06.2024.
//

import UIKit

final class GoalsPresenterController: UIViewController {
    private let viewRoot: GoalsPresenterView

    init(view: GoalsPresenterView) {
        self.viewRoot = view
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError(errorUIKitInit) }

    override func loadView() { view = viewRoot }
    override func viewDidLoad() { super.viewDidLoad() }
}
