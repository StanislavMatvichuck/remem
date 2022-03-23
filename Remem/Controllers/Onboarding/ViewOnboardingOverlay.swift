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
    
    let labelsVerticalSpacing: CGFloat = .sm
    let labelsHorizontalSpacing: CGFloat = .md
    
    lazy var labelGreeting: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
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
        
        return label
    }()
    
    lazy var labelMyNameIs: UILabel = {
        let label = createLabel()
        
        label.text = "I am tracking app called Remem and I am designed to help you to answer following questions:"
        
        label.topAnchor.constraint(equalTo: labelGreeting.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
          
        return label
    }()
    
    lazy var labelQuestion01: UILabel = {
        let label = createLabel()
        
        label.text = "- when did an event last happened?"
        
        label.topAnchor.constraint(equalTo: labelMyNameIs.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
          
        return label
    }()
    
    lazy var labelQuestion02: UILabel = {
        let label = createLabel()
        
        label.text = "- how many events happen in a week?"
        
        label.topAnchor.constraint(equalTo: labelQuestion01.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
          
        return label
    }()
    
    lazy var labelHint: UILabel = {
        let label = createLabel()
        
        label.text = "You can use me to track things like smoking a cigarette, drinking cup of coffee, doing morning exercises or taking pills. Whatever periodic event you want to track exactly"
        
        label.topAnchor.constraint(equalTo: labelQuestion02.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
            
        return label
    }()
    
    lazy var labelStart: UILabel = {
        let label = createLabel()
        
        label.text = "Start is easy. Swipe up the screen to create an event"
        
        label.topAnchor.constraint(equalTo: labelGreeting.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        
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
        
        label.topAnchor.constraint(equalTo: labelGreeting.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        
        return label
    }()
    
    lazy var labelEventSwipe: UILabel = {
        let label = createLabel()
        
        label.text = "You do the job of notifying me by swiping a circle, just like accepting a call. Try it"
        
        label.topAnchor.constraint(equalTo: labelEventCreated.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        
        return label
    }()
    
    lazy var labelSwipeComplete: UILabel = {
        let label = createLabel()
        
        label.text = "Nice! Now I will Remember that moment in time and let you review it later. Do it couple more times to get used to it"
        
        label.topAnchor.constraint(equalTo: labelEventSwipe.bottomAnchor, constant: labelsVerticalSpacing).isActive = true
        
        return label
    }()
    
    lazy var viewCircle: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.systemOrange.cgColor
        view.layer.cornerRadius = .r2 / 2
        
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
    
    private func createLabel() -> UILabel {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    //

    // MARK: - Initialization

    //

    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
//        backgroundColor = .systemBackground
        backgroundColor = .systemTeal
        alpha = 0.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewFingerConstraints() {
        let labelSize = viewFinger.sizeThatFits(CGSize(width: .wScreen,
                                                       height: .hScreen))
        
        NSLayoutConstraint.activate([
            viewFinger.centerXAnchor.constraint(equalTo: viewCircle.centerXAnchor, constant: labelSize.width / 1.6 + 7),
            viewFinger.centerYAnchor.constraint(equalTo: viewCircle.centerYAnchor, constant: labelSize.height / 1.6 + 2),
        ])
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
    
    // override func layoutSubviews() {
    //     super.layoutSubviews()
    //     print(#function)
    // }
}
