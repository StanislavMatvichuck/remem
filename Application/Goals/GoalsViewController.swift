//
//  GoalsViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import UIKit

final class GoalsViewController: UIViewController {
    let viewRoot = GoalsView()
    var viewModel: GoalsViewModel? { didSet {
        viewRoot.viewModel = viewModel
    }}
    
    let factory: GoalsViewModelFactoring
    
    init(factory: GoalsViewModelFactoring) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = factory.makeGoalsViewModel()
    }
}
