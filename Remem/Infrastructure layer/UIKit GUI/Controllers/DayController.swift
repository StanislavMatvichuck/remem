//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Foundation

import UIKit

class DayController: UIViewController {
    // MARK: - Properties
    fileprivate let viewRoot = DayView()

    // MARK: - Init
    init() { super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }

    override func viewDidLoad() {
        view.backgroundColor = .red

        title = "Day controller"
    }
}
