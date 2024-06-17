//
//  DayController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.08.2022.
//

import Domain
import UIKit

final class DayDetailsController: UIViewController {
    let factory: DayDetailsViewModelFactoring
    let viewRoot: DayDetailsView
    let dataSource: DayDetailsDataSource

    var viewModel: DayDetailsViewModel? { didSet {
        guard let viewModel else { return }
        dataSource.viewModel = viewModel
        viewRoot.viewModel = viewModel
    } }

    var createHappeningService: CreateHappeningService?
    var removeHappeningService: RemoveHappeningService?
    var createHappeningSubscription: DomainEventsPublisher.DomainEventSubscription?
    var removeHappeningSubscription: DomainEventsPublisher.DomainEventSubscription?

    /// This is required because `Happening` is a value object without ID
    var removedCell: DayCellViewModel?

    init(
        _ factory: DayDetailsViewModelFactoring,
        createHappeningService: CreateHappeningService?,
        removeHappeningService: RemoveHappeningService?,
        view: DayDetailsView,
        dataSource: DayDetailsDataSource
    ) {
        self.factory = factory
        self.viewRoot = view
        self.dataSource = dataSource
        self.createHappeningService = createHappeningService
        self.removeHappeningService = removeHappeningService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError(errorUIKitInit) }
    deinit {
        createHappeningSubscription = nil
        removeHappeningSubscription = nil
    }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewModel = factory.makeDayDetailsViewModel(pickerDate: nil)
        configureCollection()
        configureEventHandlers()
        configureDomainEventSubscriptions()
    }

    private func configureDomainEventSubscriptions() {
        createHappeningSubscription = DomainEventsPublisher.shared.subscribe(HappeningCreated.self, usingBlock: { [weak self] event in
            self?.viewModel?.add(happening: event.happening)
        })

        removeHappeningSubscription = DomainEventsPublisher.shared.subscribe(HappeningRemoved.self, usingBlock: { [weak self] _ in
            if let removedCell = self?.removedCell {
                self?.viewModel?.remove(cell: removedCell)
                self?.removedCell = nil
            }
        })
    }

    private func configureCollection() {
        viewRoot.list.dragDelegate = self
    }

    private func configureEventHandlers() {
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(handleButton))
        viewRoot.buttonBackground.addGestureRecognizer(recogniser)

        viewRoot.buttonBackground.addInteraction(UIDropInteraction(delegate: self))

        viewRoot.picker.addTarget(self, action: #selector(handlePicker), for: .valueChanged)
    }

    @objc private func handleButton() {
        if let viewModel, let createHappeningService {
            createHappeningService.serve(CreateHappeningServiceArgument(
                eventId: viewModel.eventId,
                date: viewModel.pickerDate
            ))
        }

        viewRoot.button.animateTapReceiving()
    }

    @objc private func handleClose() {
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func handlePicker() {
        viewModel?.handlePicker(date: viewRoot.picker.date)
    }
}

extension DayDetailsController: UICollectionViewDragDelegate {
    func collectionView(
        _: UICollectionView,
        itemsForBeginning _: UIDragSession,
        at index: IndexPath
    ) -> [UIDragItem] {
        let provider = NSItemProvider(object: "\(index.row)" as NSString)
        let dragItem = UIDragItem(itemProvider: provider)
        return [dragItem]
    }

    func collectionView(_: UICollectionView, dragSessionWillBegin _: UIDragSession) {
        viewModel?.enableDrag()
    }

    func collectionView(_: UICollectionView, dragSessionDidEnd _: UIDragSession) {
        viewModel?.disableDrag()
    }
}

extension DayDetailsController: UIDropInteractionDelegate {
    func dropInteraction(_: UIDropInteraction, canHandle _: UIDropSession) -> Bool { true }
    func dropInteraction(_: UIDropInteraction, sessionDidUpdate _: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .move)
    }

    func dropInteraction(_: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSString.self) { [weak self] object in
            if let viewModel = self?.viewModel,
               let indexObject = object.first,
               let indexString = indexObject as? String,
               let index = Int(indexString)
            {
                let identifier = viewModel.identifiers[index]
                if let cellViewModel = viewModel.cell(for: identifier) {
                    self?.removedCell = cellViewModel

                    self?.removeHappeningService?.serve(RemoveHappeningServiceArgument(
                        happening: cellViewModel.happening
                    ))
                }
            }
        }
    }
}
