//
//  TemporaryItem.swift
//  Application
//
//  Created by Stanislav Matvichuck on 17.04.2023.
//

import UIKit

typealias LoadableEventCellViewModel = LoadableViewModelWrapper<String, EventCellViewModel>

final class EventCell: UICollectionViewCell, LoadableView {
    private static let reuseIdentifier = collectionCellReuseIdentifierEvent

    private let view = EventCellView()
    private let staticBackgroundView = UIView(al: true)

    // TODO: improve this part
    var viewModel: LoadableEventCellViewModel? { didSet {
        guard let viewModel else { return }
        if viewModel.loading {
            displayLoading()
        } else {
            disableLoadingCover()
        }

        if let vm = viewModel.vm {
            view.configure(vm)
        }

        if let oldVm = oldValue?.vm {
            playAnimationIfNeeded(oldVm)
        }
    }}

    private var tapService: ShowEventDetailsService?
    private var swipeService: CreateHappeningService?
    private var removeService: RemoveEventService?
    private var loadingInterrupter: CellLoadingStopping?

    override init(frame: CGRect) {
        super.init(frame: frame)
        accessibilityIdentifier = Self.reuseIdentifier
        configureLayout()
        configureAppearance()
        configureEventHandlers()
    }

    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        view.prepareForReuse()
        loadingInterrupter?.stopLoading(for: self)
        viewModel = nil
        clearServices()
    }

    // MARK: - Private
    private func configureLayout() {
        contentView.addSubview(staticBackgroundView)
        contentView.addAndConstrain(view)

        let heightConstraint = contentView.heightAnchor.constraint(equalToConstant: .layoutSquare * 2)
        heightConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            heightConstraint,
            staticBackgroundView.widthAnchor.constraint(equalTo: view.stack.widthAnchor),
            staticBackgroundView.heightAnchor.constraint(equalTo: view.stack.heightAnchor),
            staticBackgroundView.centerXAnchor.constraint(equalTo: view.stack.centerXAnchor),
            staticBackgroundView.centerYAnchor.constraint(equalTo: view.stack.centerYAnchor),
        ])
    }

    private func configureAppearance() {
        backgroundColor = .bg
        staticBackgroundView.backgroundColor = .border
        staticBackgroundView.layer.cornerRadius = view.stack.layer.cornerRadius
    }

    // MARK: - Services

    func configureServices(
        tapService: ShowEventDetailsService,
        swipeService: CreateHappeningService,
        removeService: RemoveEventService,
        loadingInterrupter: CellLoadingStopping
    ) {
        self.tapService = tapService
        self.swipeService = swipeService
        self.removeService = removeService
        self.loadingInterrupter = loadingInterrupter
    }

    private func clearServices() {
        self.tapService = nil
        self.swipeService = nil
        self.removeService = nil
        self.loadingInterrupter = nil
    }

    // MARK: - User events handling

    private func configureEventHandlers() {
        view.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTap)
        ))

        view.circleContainer.addTarget(
            self, action: #selector(handleSwipe),
            for: .valueChanged
        )
    }

    @objc private func handleSwipe() {
        swipeService?.serve(CreateHappeningServiceArgument(date: .now))
    }

    @objc private func handleTap() {
        view.animateTapReceiving {
            guard let tapService = self.tapService else { return }
            tapService.serve(ApplicationServiceEmptyArgument())
        }
    }

    func handleRemove() { removeService?.serve(ApplicationServiceEmptyArgument()) }
}

// MARK: - Happening creation animations
extension EventCell {
    func playAnimationIfNeeded(_ oldValue: EventCellViewModel?) {
        /// exists after controller.viewModel.didSet
        /// does not exist after cell reusing (during scroll and first render)
        guard oldValue != nil else { return }
        switch viewModel?.vm?.animation {
        case .swipe: playSwipeAnimation()
        case .aboveSwipe: SwiperAnimationsHelper.animate(neighbour: view, isAbove: true)
        case .belowSwipe: SwiperAnimationsHelper.animate(neighbour: view, isAbove: false)
        default: return
        }
    }

    func playSwipeAnimation() {
        view.circleContainer.prepareForHappeningCreationAnimation()
        SwiperAnimationsHelper.animateHappening(view)
    }
}
