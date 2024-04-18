//
//  RemovalDropAreaView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 18.04.2024.
//

import UIKit

final class RemovalDropAreaView: UIView {
    private static let defaultOpacity: Float = 0.5
    
    typealias DropHandler = (Int) -> Void
    
    var viewModel: RemovalDropAreaViewModel? { didSet {
        if let viewModel { configureContent(viewModel) }
    }}
    
    let handler: DropHandler
    
    let removalDropArea: UIView = {
        let view = UIView(al: true)
        let image = UIImage(systemName: "trash.fill")?
            .withTintColor(UIColor.bg)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 30)))
        let imageView = UIImageView(al: true)
        imageView.image = image
        view.addSubview(imageView)
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.buttonMargin).isActive = true
        return view
    }()
    
    lazy var animatedConstraint: NSLayoutConstraint = { removalDropArea.trailingAnchor.constraint(equalTo: self.leadingAnchor) }()
    
    init(handler: @escaping DropHandler) {
        self.handler = handler
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureDropArea()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func updateRemovalDropAreaPosition(x: CGFloat) {
        let constant = (bounds.width - x) / 3
        
        let lowerBound = CGFloat.buttonMargin
        let upperBound = removalDropArea.bounds.width - 2 * removalDropArea.layer.cornerRadius
        let clampedConstant = constant.clamped(to: lowerBound ... upperBound)
        
        animatedConstraint.constant = clampedConstant
    }
    
    // MARK: - Private
    private func configureLayout() {
        addSubview(removalDropArea)
        removalDropArea.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1 / 3).isActive = true
        removalDropArea.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, constant: -2 * .buttonMargin).isActive = true
        removalDropArea.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        animatedConstraint.isActive = true
    }
    
    private func configureDropArea() {
        let dropInteraction = UIDropInteraction(delegate: self)
        removalDropArea.addInteraction(dropInteraction)
    }
    
    private func configureContent(_ viewModel: RemovalDropAreaViewModel) {
        removalDropArea.isHidden = viewModel.removalDropAreaHidden
        removalDropArea.layer.opacity = viewModel.removalDropAreaActive ?
            1.0 :
            Self.defaultOpacity
    }
    
    private func configureAppearance() {
        removalDropArea.backgroundColor = UIColor.red
        removalDropArea.layer.cornerRadius = CGFloat.buttonMargin
        removalDropArea.isHidden = true
        removalDropArea.layer.opacity = Self.defaultOpacity
    }
    
    /// This allows to layout RemovalDropArea as a cover for a list and not interrupt touches for scroll
    /// simultaneously supporting drop area as drop interaction delegate
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        if result == self { return nil }
        return result
    }
}

extension RemovalDropAreaView: UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        viewModel?.activateDropArea()
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        viewModel?.deactivateDropArea()
    }

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard
            let viewModel,
            let draggedCellIndex = viewModel.draggedCellIndex
        else { return }
        handler(draggedCellIndex)
    }

    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal { UIDropProposal(operation: .move) }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool { true }
}
