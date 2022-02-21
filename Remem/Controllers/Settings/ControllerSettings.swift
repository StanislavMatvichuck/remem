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
        view.backgroundColor = .red
        
        title = "Settings"
    }
}
