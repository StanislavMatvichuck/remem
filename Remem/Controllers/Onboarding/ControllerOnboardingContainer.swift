//
//  OnboardingContainerController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 19.03.2022.
//

import UIKit

class ControllerOnboardingContainer: UIViewController {
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewOnboardingContainer()
    
    fileprivate let controllerMain: ControllerMain = {
        let controller = ControllerMain()
        controller.persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        return controller
    }()
    
    fileprivate weak var controllerOverlay: ControllerOnboardingOverlay?
    
    //
    
    // MARK: - Initialization
    
    //
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        installControllerMain()
        installControllerOverlay()
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
    }
    
    //

    // MARK: - Container methods

    //
    
    fileprivate func installControllerMain() {
        controllerMain.willMove(toParent: self)
        addChild(controllerMain)
        viewRoot.contain(view: controllerMain.view)
        controllerMain.didMove(toParent: self)
    }
    
    fileprivate func installControllerOverlay() {
        let newOverlay = ControllerOnboardingOverlay()
        newOverlay.mainDelegate = controllerMain
        newOverlay.mainDataSource = controllerMain
        controllerOverlay = newOverlay
        
        newOverlay.willMove(toParent: self)
        addChild(newOverlay)
        viewRoot.install(overlay: newOverlay.view)
        newOverlay.didMove(toParent: self)
    }
    
    fileprivate func uninstallControllerOverlay() {
        controllerOverlay?.willMove(toParent: nil)
        controllerOverlay?.view.removeFromSuperview()
        controllerOverlay?.removeFromParent()
        controllerOverlay?.didMove(toParent: nil)
        controllerOverlay = nil
    }
    
    //

    // MARK: - Public behaviour

    //
    
    func startOnboarding() {
        installControllerOverlay()
        viewRoot.showOverlay()
        controllerOverlay?.start()
    }
    
    func closeOnboarding() {
        controllerOverlay?.close {
            self.viewRoot.hideOverlay()
            self.uninstallControllerOverlay()
        }
    }
}
