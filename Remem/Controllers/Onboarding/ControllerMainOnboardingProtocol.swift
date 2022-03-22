//
//  OnboardingDelegateMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 17.03.2022.
//

import UIKit

protocol ControllerMainOnboardingDataSource: UIViewController {
    var viewSwiper: UIView { get }
    var viewCellCreated: UIView { get }
    var viewInput: UIView { get }
    var inputHeightOffset: CGFloat { get }
}

protocol ControllerMainOnboardingDelegate: UIViewController {
    func createTestItem()
    func disableSettingsButton()
    func enableSettingsButton()
}
