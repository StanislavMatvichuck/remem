//
//  NewWeekViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.12.2023.
//

import UIKit

final class NewWeekViewController: UIViewController {
    let factory: NewWeekViewModelFactoring
    let viewRoot: NewWeekView
    
    var viewModel: NewWeekViewModel { didSet { viewRoot.viewModel = viewModel }}
    
    init(_ factory: NewWeekViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeNewWeekViewModel()
        self.viewRoot = NewWeekView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection()
        viewModel = factory.makeNewWeekViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        scrollToLastPage()
    }
    
    private func configureCollection() {
        viewRoot.collection.delegate = self
    }
    
    private func scrollToLastPage() {
        let lastPageIndex = IndexPath(row: viewModel.pagesCount - 1, section: 0)
        viewRoot.collection.scrollToItem(at: lastPageIndex, at: .right, animated: false)
    }
}

extension NewWeekViewController:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: width)
    }
}
