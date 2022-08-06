//
//  WeekController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 24.05.2022.
//

import UIKit

class WeekController: UIViewController {
    // MARK: - Properties
    var event: Event!
    weak var coordinator: Coordinator?

    private let viewRoot = WeekView()
    private var viewModel: WeekViewModel!

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        setupServiceAndViewModel()
        viewRoot.collection.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.scrollToCurrentWeek()
    }
}

// MARK: - Private
extension WeekController {
    private func setupServiceAndViewModel() {
        guard
            let endOfCurrentWeek = Date.now.endOfWeek,
            let startOfCreationWeek = event.dateCreated.startOfWeek
        else { return }

        let weekList = WeekList(from: startOfCreationWeek,
                                to: endOfCurrentWeek,
                                happenings: event.happenings)

        viewModel = WeekViewModel(model: weekList)
        viewModel.configure(viewRoot)
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
        return CGSize(width: .wScreen / 7, height: collectionView.bounds.height)
    }
}

// MARK: - DayOfTheWeekCellDelegate
extension WeekController: DayOfTheWeekCellDelegate {
    func didPress(cell: DayOfTheWeekCell) {
        guard let day = viewModel.day(for: cell) else { return }

        coordinator?.showDayController(for: day, event: event)
    }
}
