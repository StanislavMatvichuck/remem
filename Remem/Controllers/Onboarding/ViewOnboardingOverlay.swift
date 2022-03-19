//
//  ViewOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class ViewOnboardingOverlay: UIView {
    //

    // MARK: - Public properties

    //

    //

    // MARK: - Private properties

    //
    
    //

    // MARK: Labels layout

    //
    
    let labelsSpacing: CGFloat = .r2
    
    lazy var labelGreeting: UILabel = {
        let label = createLabel()
        
        label.font = .systemFont(ofSize: .font2, weight: .bold)
        label.text = "Greetings!"
        
        label.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: labelsSpacing).isActive = true
        
        return label
    }()
    
    lazy var labelTapToProceed: UILabel = {
        let label = createLabel()
        
        label.font = .systemFont(ofSize: .font1)
        label.text = "tap anywhere to proceed"
        
        label.topAnchor.constraint(equalTo: labelGreeting.bottomAnchor, constant: .delta1).isActive = true
        
        return label
    }()
    
    lazy var labelClose: UILabel = {
        let label = createLabel()
        
        label.font = .systemFont(ofSize: .font1)
        label.text = "close onboarding"
        
        label.bottomAnchor.constraint(equalTo: labelGreeting.topAnchor).isActive = true
        
        return label
    }()
    
    lazy var labelMyNameIs: UILabel = {
        let label = createLabel()
        
        label.text = "I am tracking app called Remem and I am designed to help you to answer following questions:"
        
        label.topAnchor.constraint(equalTo: labelGreeting.bottomAnchor, constant: labelsSpacing).isActive = true
          
        return label
    }()
    
    lazy var labelQuestion01: UILabel = {
        let label = createLabel()
        
        label.text = "- when did an event last happened?"
        
        label.topAnchor.constraint(equalTo: labelMyNameIs.bottomAnchor, constant: labelsSpacing).isActive = true
          
        return label
    }()
    
    lazy var labelQuestion02: UILabel = {
        let label = createLabel()
        
        label.text = "- how many events happen in a week?"
        
        label.topAnchor.constraint(equalTo: labelQuestion01.bottomAnchor, constant: labelsSpacing).isActive = true
          
        return label
    }()
    
    lazy var labelHint: UILabel = {
        let label = createLabel()
        
        label.text = "You can use me to track things like smoking a cigarette, drinking cup of coffee, doing morning exercises or taking pills. Whatever periodic event you want to track exactly"
        
        label.topAnchor.constraint(equalTo: labelQuestion02.bottomAnchor, constant: labelsSpacing).isActive = true
            
        return label
    }()
    
    lazy var labelStart: UILabel = {
        let label = createLabel()
        
        label.text = "Start is easy. Swipe up the screen to create an event"
        
        label.topAnchor.constraint(equalTo: labelHint.bottomAnchor, constant: labelsSpacing).isActive = true
        
        return label
    }()
    
    lazy var labelEventName: UILabel = {
        let label = createLabel()
        
        label.text = "Give it a name. Using emojis is encouraged!"
        
        return label
    }()
    
    lazy var labelEventCreated: UILabel = {
        let label = createLabel()
        
        label.text = "Since that moment I can record each time this event happens, but not without your help, of course."
        
        return label
    }()
    
    lazy var labelEventSwipe: UILabel = {
        let label = createLabel()
        
        label.text = "You do the job of notifying me by swiping a circle, just like accepting a call. Try it"
        
        return label
    }()
    
    lazy var viewCircle: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.tertiarySystemBackground.cgColor
        view.layer.cornerRadius = .r2 / 2
        
        view.isHidden = true
        
        addSubview(view)
        
        // FIXME: position circle + animation
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .r2),
            view.heightAnchor.constraint(equalToConstant: .r2),
            
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
            
//            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(
//                .delta1 + mainController!.viewRoot.viewSwiper.bounds.height + .r2
//            )),
        ])
        
        return view
    }()
    
    private func createLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: .font1, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.isHidden = true
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: labelsSpacing),
            label.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -labelsSpacing),
        ])
        
        return label
    }
    
    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = UIColor.orange.cgColor
        alpha = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Touches transparency with children capturing

    //

    /// This property enables touches to be passed through this view but not its siblings
    /// used together with hitTest override
    var isTransparentForTouches = false

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let viewResponder = super.hitTest(point, with: event) else { return nil }
        
        if isTransparentForTouches {
            // Allows pressing "close onboarding" button
            if let touchedSubviewIndex = subviews.firstIndex(of: viewResponder) {
                let touchedSubview = subviews[touchedSubviewIndex]
                return touchedSubview
            } else if let viewMain = superview?.superview?.subviews.first?.subviews.first {
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
