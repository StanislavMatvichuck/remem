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
    
    fileprivate weak var controllerPointsList: ControllerPointsList?
    
    //
    
    // MARK: - Initialization
    
    //
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        installControllerMain()
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
        addChild(controllerMain)
        viewRoot.viewMain.addAndConstrain(controllerMain.view)
        controllerMain.didMove(toParent: self)
    }
    
    fileprivate func installControllerOverlay() {
        let newOverlay = ControllerOnboardingOverlay()
        newOverlay.mainDelegate = controllerMain
        newOverlay.mainDataSource = controllerMain
        controllerOverlay = newOverlay
        
        addChild(newOverlay)

        viewRoot.viewOverlay.addAndConstrain(newOverlay.view)
        newOverlay.didMove(toParent: self)
    }
    
    fileprivate func uninstallControllerOverlay() {
        if let controller = controllerOverlay {
            remove(controller)
        }
        controllerOverlay = nil
    }
    
    fileprivate func remove(_ controller: UIViewController) {
        controller.willMove(toParent: nil)
        controller.view.removeFromSuperview()
        controller.removeFromParent()
        controller.didMove(toParent: nil)
    }
    
    //

    // MARK: - Public behaviour

    //
    
    func startOnboarding() {
        installControllerOverlay()
        viewRoot.viewOverlay.isHidden = false
        controllerOverlay?.start()
    }
    
    func closeOnboarding() {
        controllerOverlay?.close {
            self.viewRoot.viewOverlay.isHidden = true
            self.uninstallControllerOverlay()
        }
    }
    
    func showPointsList(for entry: Entry) {
        let controller = ControllerPointsList(entry: entry)
        controllerPointsList = controller
        // TODO: refactor persistanceContainer injection
        controller.persistentContainer = controllerMain.persistentContainer
        
        addChild(controller)
        viewRoot.viewPointsList.addAndConstrain(controller.view)
        viewRoot.addAndConstrain(viewRoot.viewPointsList)
        viewRoot.viewPointsList.isHidden = false
        controller.didMove(toParent: self)
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            self.closePointsList()
//        }
    }
    
    func closePointsList() {
        if let controller = controllerPointsList {
            remove(controller)
        }
        controllerPointsList = nil
        viewRoot.viewPointsList.isHidden = true
    }
}
