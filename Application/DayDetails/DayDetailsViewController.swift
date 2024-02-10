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

    init(_ factory: DayDetailsViewModelFactoring) {
        self.factory = factory
        self.viewRoot = DayDetailsView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - View lifecycle
    override func loadView() { view = viewRoot }
    override func viewDidLoad() {
        viewModel = factory.makeDayDetailsViewModel(pickerDate: nil)
        configureCollection()
        configureEventHandlers()
    }

    private func configureCollection() {
        viewRoot.happeningsCollection.delegate = self
        viewRoot.happeningsCollection.dragDelegate = self
    }

    private func configureEventHandlers() {
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(handleButton))
        viewRoot.buttonBackground.addGestureRecognizer(recogniser)

        viewRoot.buttonBackground.addInteraction(UIDropInteraction(delegate: self))

        viewRoot.picker.addTarget(self, action: #selector(handlePicker), for: .valueChanged)
    }

    @objc private func handleButton() {
        viewModel?.addHappening()
        viewRoot.button.animateTapReceiving()
    }

    @objc private func handleClose() {
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func handlePicker() {
        viewModel?.handlePicker(date: viewRoot.picker.date)
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

extension DayDetailsViewController: UICollectionViewDragDelegate {
    func collectionView(
        _: UICollectionView,
        itemsForBeginning _: UIDragSession,
        at index: IndexPath) -> [UIDragItem]
    {
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
        session.loadObjects(ofClass: NSString.self) { object in
            let indexString = object.first!
            if let index = Int(indexString as! String) {
                self.viewModel?.cells[index].remove()
            }
        }
    }
}
