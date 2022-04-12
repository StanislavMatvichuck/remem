//
//  OnboardingView.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 07.04.2022.
//

import UIKit

class OnboardingView: UIView {
    //

    // MARK: - Properties

    //
    
    let labelsVerticalSpacing: CGFloat = .sm
    let labelsHorizontalSpacing: CGFloat = .md

    lazy var viewBackground: UIView = {
        let view = UIView(al: true)
        view.backgroundColor = .systemGray2
        return view
    }()

    lazy var labelTitle: UILabel = {
        let label = UILabel(al: true)
        label.font = .systemFont(ofSize: .font2, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0

        label.text = "Greetings!"
        
        label.isHidden = true
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: labelsVerticalSpacing),
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: labelsHorizontalSpacing),
            label.trailingAnchor.constraint(equalTo: labelClose.leadingAnchor),
        ])
        
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    lazy var labelTapToProceed: UILabel = {
        let label = createLabel()
        
        label.font = .systemFont(ofSize: .font1)
        label.text = "tap to proceed 👆"
        label.textAlignment = .center
        
        label.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: .delta1).isActive = true
        
        return label
    }()
    
    lazy var labelClose: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: .font2)
        label.text = "❌"
        
        label.isHidden = true
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: labelsVerticalSpacing),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -labelsHorizontalSpacing),
        ])
        
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    lazy var viewCircle: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.systemOrange.cgColor
        view.layer.cornerRadius = .r2 / 2
        view.isUserInteractionEnabled = false
        view.isHidden = true
        
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .r2),
            view.heightAnchor.constraint(equalToConstant: .r2),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        return view
    }()
    
    lazy var viewFinger: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "👆"
        label.font = .systemFont(ofSize: .font2)
        label.transform = CGAffineTransform(rotationAngle: -1 * (.pi / 4))
        label.isUserInteractionEnabled = false
        label.isHidden = true
        
        addSubview(label)
        
        let labelSize = label.sizeThatFits(CGSize(width: .wScreen,
                                                  height: .hScreen))
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: viewCircle.centerXAnchor, constant: labelSize.width / 1.6 + 7),
            label.centerYAnchor.constraint(equalTo: viewCircle.centerYAnchor, constant: labelSize.height / 1.6 + 2),
        ])
        
        return label
    }()

    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        
        addAndConstrain(viewBackground)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //

    // MARK: - Behaviour

    //
    
    func createLabel() -> UILabel {
        let label = UILabel(al: true)
        label.font = .systemFont(ofSize: .font1, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.isHidden = true
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: labelsHorizontalSpacing),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -labelsHorizontalSpacing),
        ])
        
        return label
    }
    
    func placeTapToProceedInsteadOfTitle() {
        labelTapToProceed.removeFromSuperview()
        addSubview(labelTapToProceed)
        
        NSLayoutConstraint.activate([
            labelTapToProceed.centerYAnchor.constraint(equalTo: labelClose.centerYAnchor),
            labelTapToProceed.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                       constant: labelsHorizontalSpacing),
            labelTapToProceed.trailingAnchor.constraint(equalTo: labelClose.leadingAnchor,
                                                        constant: labelsHorizontalSpacing),
        ])
    }
    
    //

    // MARK: - Touches transparency with children capturing

    //

    /// This property enables touches to be passed through this view but not its siblings like close buttons
    var isTransparentForTouches = false

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let viewResponder = super.hitTest(point, with: event) else { return nil }
        
        if isTransparentForTouches {
            // Allows pressing "close onboarding" button
            if
                viewResponder != viewBackground,
                let touchedSubviewIndex = subviews.firstIndex(of: viewResponder)
            {
                let touchedSubview = subviews[touchedSubviewIndex]
                return touchedSubview
            } else if let viewMain = superview?.superview?.subviews.first {
                // FIXME: make this condition to be general
                let convertedPoint = viewMain.convert(point, from: self)
                return viewMain.hitTest(convertedPoint, with: event)
            } else {
                return nil
            }
        }
        
        return viewResponder
    }
}
