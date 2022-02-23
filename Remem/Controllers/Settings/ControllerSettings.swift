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
    
    fileprivate weak var mainController: ControllerMain?
    
    //
    
    // MARK: - Initialization
    
    //
    
    init(_ mainController: ControllerMain) {
        self.mainController = mainController
        
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
        let onboarding = UITapGestureRecognizer(target: self, action: #selector(handlePressOnboarding))
        viewRoot.viewWatchOnboarding.addGestureRecognizer(onboarding)
    }
    
    @objc func handlePressOnboarding() {
        dismiss(animated: true) { [weak self] in
            self?.mainController?.launchOnboarding()
        }
    }
}
