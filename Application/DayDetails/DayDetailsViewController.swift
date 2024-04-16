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

    var viewModel: DayDetailsViewModel? { didSet {
        viewRoot.viewModel = viewModel
    } }

    var createHappeningService: CreateHappeningService?
    var removeHappeningService: RemoveHappeningService?
    var createHappeningSubscription: DomainEventsPublisher.DomainEventSubscription?
    var removeHappeningSubscription: DomainEventsPublisher.DomainEventSubscription?

    init(
        _ factory: DayDetailsViewModelFactoring,
        createHappeningService: CreateHappeningService?,
        removeHappeningService: RemoveHappeningService?
    ) {
        self.factory = factory
        self.viewRoot = DayDetailsView()
        self.createHappeningService = createHappeningService
        self.removeHappeningService = removeHappeningService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }
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
        createHappeningSubscription = DomainEventsPublisher.shared.subscribe(HappeningCreated.self, usingBlock: { [weak self] _ in
            self?.update()
        })
        removeHappeningSubscription = DomainEventsPublisher.shared.subscribe(HappeningRemoved.self, usingBlock: { [weak self] _ in
            self?.update()
        })
    }

    private func configureCollection() {
        viewRoot.happeningsCollection.dragDelegate = self
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

extension DayDetailsViewController: UICollectionViewDragDelegate {
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

extension DayDetailsViewController: UIDropInteractionDelegate {
    func dropInteraction(_: UIDropInteraction, canHandle _: UIDropSession) -> Bool { true }
    func dropInteraction(_: UIDropInteraction, sessionDidUpdate _: UIDropSession) -> UIDropProposal {
        UIDropProposal(operation: .move)
    }

    func dropInteraction(_: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: NSString.self) { [weak self] object in
            if let viewModel = self?.viewModel,
               let indexString = object.first,
               let index = Int(indexString as! String)
            {
                let identifier = viewModel.identifiers[index]
                if let cellViewModel = viewModel.cell(for: identifier) {
                    self?.removeHappeningService?.serve(RemoveHappeningServiceArgument(
                        happening: cellViewModel.happening
                    ))
                }
            }
        }
    }
}
