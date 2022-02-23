//
//  ControllerOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class ControllerOnboarding {
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewOnboarding()
    
    fileprivate weak var mainController: ControllerMain?
    
    //
    
    // MARK: - Initialization
    
    //
    
    init(main: ControllerMain) {
        mainController = main
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    //

    // MARK: - Events handling

    //
    
    @objc private func handleTap() {
        print(#function)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.alpha = 0
        }, completion: { animated in
            if animated {
                self.viewRoot.removeFromSuperview()
            }
        })
        
        mainController?.onboardingController = nil
    }
    
    //

    // MARK: - Behaviour

    //
    
    func start() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        viewRoot.addGestureRecognizer(tap)
        
        viewRoot.alpha = 0.0
        
        let viewWindow = UIApplication.shared.keyWindow
        
        viewWindow?.addSubview(viewRoot)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.alpha = 1
        })
    }
}
