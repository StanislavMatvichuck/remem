//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class WeekController: UIViewController {
    // MARK: - Properties
    weak var coordinator: Coordinator?
    var event: Event! { didSet { viewModel = WeekViewModel(model: event) }}

    private let viewRoot = WeekView()
    private var viewModel: WeekViewModel! { didSet { viewModel.configure(viewRoot) }}

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewRoot.collection.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.scrollToCurrentWeek()
    }
}

// MARK: - UICollectionViewDelegate
extension WeekController:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? WeekCell else { return }
        cell.delegate = self
    }

    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width / 7,
                      height: collectionView.bounds.height)
    }
}

// MARK: - WeekCellDelegate
extension WeekController: WeekCellDelegate {
    func didPress(cell: WeekCell) {
        guard let day = viewModel.day(for: cell) else { return }
        coordinator?.showDayController(for: day, event: event)
    }
}

// MARK: - EventEditUseCaseOutput
extension WeekController: EventEditUseCaseOutput {
    func added(happening: Happening, to: Event) { event = to }
    func removed(happening: Happening, from: Event) {}
    func renamed(event: Event) {}
    func visited(event: Event) {}
    func added(goal: Goal, to: Event) {}
}
