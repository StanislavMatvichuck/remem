//
//  StatsViewController.swift
//  Application
//
//  Created by Stanislav Matvichuck on 29.01.2023.
//

import UIKit

final class SummaryViewController: UIViewController {
    var viewModel: SummaryViewModel? { didSet {
        guard isViewLoaded, let viewModel else { return }
        viewRoot.viewModel = viewModel
    }}

    let factory: SummaryViewModelFactoring
    let viewRoot: SummaryView

    init(_ factory: SummaryViewModelFactoring) {
        self.factory = factory
        self.viewRoot = SummaryView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        configureList()
        viewModel = factory.makeSummaryViewModel()
    }

    // MARK: - Private
    private func configureList() { viewRoot.list.delegate = self }
}

extension SummaryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - .buttonMargin
        let cellWidth = (availableWidth / 2).rounded(.down)
        let cellHeight = 2 * .layoutSquare
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
