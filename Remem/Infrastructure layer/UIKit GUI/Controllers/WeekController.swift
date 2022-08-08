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
        guard let cell = cell as? DayOfTheWeekCell else { return }
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

// MARK: - DayOfTheWeekCellDelegate
extension WeekController: DayOfTheWeekCellDelegate {
    func didPress(cell: DayOfTheWeekCell) {
        guard let day = viewModel.day(for: cell) else { return }
        coordinator?.showDayController(for: day, event: event)
    }
}

// MARK: - EventEditUseCaseOutput
extension WeekController: EventEditUseCaseOutput {
    func updated(event: Event) { self.event = event }
}
