//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import AudioToolbox
import Domain
import UIKit

final class DayDetailsViewController: UIViewController {
    let factory: DayDetailsViewModelFactoring
    let viewRoot: DayDetailsView

    var viewModel: DayDetailsViewModel { didSet {
        viewRoot.viewModel = viewModel
    } }

    init(_ factory: DayDetailsViewModelFactoring) {
        self.factory = factory
        self.viewModel = factory.makeDayDetailsViewModel()
        self.viewRoot = DayDetailsView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewModel = factory.makeDayDetailsViewModel()
        configureTableView()
        configureEventHandlers()
    }

    private func configureTableView() {
        viewRoot.happeningsCollection.delegate = self
    }

    private func configureEventHandlers() {
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(handleButton))
        viewRoot.buttonBackground.addGestureRecognizer(recogniser)
    }

    @objc private func handleButton() {
        viewModel.addHappeningHandler(viewRoot.picker.date)
        viewRoot.button.animateTapReceiving()
    }

    @objc private func handleClose() {
        presentingViewController?.dismiss(animated: true)
    }
}

extension DayDetailsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize
    {
        let width = collectionView.bounds.width / 4
        return CGSize(width: width, height: width)
    }
}
