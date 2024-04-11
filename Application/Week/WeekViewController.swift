//
//  WeekViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

import UIKit

final class WeekViewController: UIViewController {
    let factory: WeekViewModelFactoring
    let viewRoot: WeekView
    
    var viewModel: WeekViewModel { didSet { viewRoot.viewModel = viewModel }}
    
    init(_ factory: WeekViewModelFactoring, view: WeekView) {
        self.factory = factory
        self.viewModel = factory.makeWeekViewModel()
        self.viewRoot = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = factory.makeWeekViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        scrollToLastPage()
    }
    
    private func scrollToLastPage() {
        let lastPageIndex = IndexPath(row: viewModel.pagesCount - 1, section: 0)
        viewRoot.collection.scrollToItem(at: lastPageIndex, at: .right, animated: false)
    }
}
