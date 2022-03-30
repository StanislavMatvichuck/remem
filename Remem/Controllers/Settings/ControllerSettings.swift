//
//  ControllerSettings.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.02.2022.
//

import UIKit

class ControllerSettings: UIViewController {
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewSettings()
    
    //
    
    // MARK: - Initialization
    
    //
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    override func loadView() { view = viewRoot }
    
    override func viewDidLoad() {
        title = "Settings"
        
        setupEventsHandlers()
    }
    
    //

    // MARK: - Events handling

    //
    
    private func setupEventsHandlers() {
        viewRoot.viewWatchOnboarding.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handlePressOnboarding)))
    }
    
    @objc func handlePressOnboarding() {
        guard let main = parent?.presentingViewController as? ControllerMain else { return }
        dismiss(animated: true) { main.startOnboarding() }
    }
}
