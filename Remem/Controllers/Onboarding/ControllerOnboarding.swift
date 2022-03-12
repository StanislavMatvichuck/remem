//
//  ControllerOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class ControllerOnboarding: NSObject {
    //

    // MARK: - Static properties

    //
    
    static let standartDuration = TimeInterval(0.5)
    
    enum Step: Int, CaseIterable {
        case showBackground
        case showTextGreeting
        case showTextName
        case showTextFirstQuestion
        case showTextSecondQuestion
        case showTextHint
        case showTextStartIsEasy
        case highlightBottomSection
        case showFloatingCircleUp
        case waitForSwipeUp
        case showTextGiveEventAName
        case waitForEventSubmit
        case highlightCreatedEntry
        case showTextEntryDescription
        case showTextTrySwipe
        case showFloatingCircleRight
        case waitForSwipe
        case showTextAfterFirstSwipe
        case waitForSwipe02
        case showTextAfterSecondSwipe
        case waitForSwipe03
    }
    
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewOnboarding()
    
    fileprivate let window = UIApplication.shared.keyWindow!
    
    fileprivate weak var mainController: ControllerMain?
    
    fileprivate var currentStep: Step = .showBackground
    
    //

    // MARK: - Labels layout

    //
    
    let labelsSpacing: CGFloat = .r2
    
    lazy var labelGreeting: UILabel = {
        let label = createLabel()
        
        label.font = .systemFont(ofSize: .font2, weight: .bold)
        label.text = "Greetings!"
        
        label.topAnchor.constraint(equalTo: viewRoot.safeAreaLayoutGuide.topAnchor, constant: labelsSpacing).isActive = true
        
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
        
        let close = UITapGestureRecognizer(target: self, action: #selector(close))
        label.addGestureRecognizer(close)
        label.isUserInteractionEnabled = true
        
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
    
    lazy var viewCircle: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.backgroundColor = UIColor.tertiarySystemBackground.cgColor
        view.layer.cornerRadius = .r2 / 2
        
        view.isHidden = true
        
        viewRoot.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: .r2),
            view.heightAnchor.constraint(equalToConstant: .r2),
            
            view.centerXAnchor.constraint(equalTo: viewRoot.centerXAnchor),
            view.bottomAnchor.constraint(equalTo: viewRoot.bottomAnchor, constant: -(
                .delta1 + mainController!.viewRoot.viewSwiper.bounds.height + .r2
            )),
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
        
        viewRoot.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: viewRoot.safeAreaLayoutGuide.leadingAnchor, constant: labelsSpacing),
            label.trailingAnchor.constraint(equalTo: viewRoot.safeAreaLayoutGuide.trailingAnchor, constant: -labelsSpacing),
        ])
        
        return label
    }
    
    //
    
    // MARK: - Initialization
    
    //
    
    init(main: ControllerMain) {
        mainController = main
        
        super.init()
        
        stepForward()
    }
    
    //
    
    // MARK: - View lifecycle
    
    //

    //

    // MARK: - Events handling

    //
    
    @objc private func handleTap() {
        stepForward()
    }
    
    @objc private func close() {
        addAnimationToMaskLayer(willShowHighlight: false)
        
        UIView.animate(withDuration: 0.3, delay: ControllerOnboarding.standartDuration, animations: {
            self.viewRoot.alpha = 0
        }, completion: { animated in
            if animated {
                self.viewRoot.removeFromSuperview()
            }
        })
        
        mainController?.onboardingController = nil
    }
    
    //

    // MARK: - Behaviour

    //
    
    func start() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        viewRoot.addGestureRecognizer(tap)
        
        viewRoot.alpha = 0.0
    
        window.addSubview(viewRoot)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.alpha = 1
        }, completion: { _ in
            self.stepForward()
        })
    }
    
    fileprivate var tapAnywhereIsShown = false
    
    func stepForward() {
        switch currentStep {
        case .showBackground:
            start()
        case .showTextGreeting:
            animate(label: labelGreeting)
            animate(label: labelTapToProceed)
        case .showTextName:
            animate(label: labelMyNameIs)
            removeWithAnimation(label: labelTapToProceed)
        case .showTextFirstQuestion:
            animate(label: labelQuestion01)
        case .showTextSecondQuestion:
            animate(label: labelQuestion02)
        case .showTextHint:
            animate(label: labelHint)
            animate(label: labelClose)
        case .showTextStartIsEasy:
            animate(label: labelStart)
        case .highlightBottomSection:
            animateMaskLayer(for: mainController?.viewRoot.viewSwiper, cornerRadius: 0, offset: 0)
        case .showFloatingCircleUp:
            animateCircle(with: .bottomTop)
            viewRoot.isTransparentForTouches = true
//        case .waitForSwipeUp:
//        case showTextGiveEventAName
//        case waitForEventSubmit
//        case highlightCreatedEntry
//        case showTextEntryDescription
//        case showTextTrySwipe
//        case showFloatingCircleRight
//        case waitForSwipe
//        case showTextAfterFirstSwipe
//        case waitForSwipe02
//        case showTextAfterSecondSwipe
//        case waitForSwipe03
        default:
            close()
            return
        }
        
        currentStep = Step(rawValue: currentStep.rawValue + 1)!
    }
    
    //

    // MARK: Highlighting

    //
    
    private var startPath: UIBezierPath?

    private var finalPath: UIBezierPath?
    
    private func createProjectedFrame(for view: UIView) -> CGRect {
        let windowView = window.rootViewController!.view

        let frame = view.convert(view.bounds, to: windowView)

        return frame
    }

    private func createStartPath(for frame: CGRect, cornerRadius: CGFloat = 0) -> UIBezierPath {
        let centerX = frame.origin.x + frame.width / 2
        let centerY = frame.origin.y + frame.height / 2

        let path = UIBezierPath(rect: viewRoot.bounds)

        path.append(UIBezierPath(roundedRect: CGRect(x: centerX,
                                                     y: centerY,
                                                     width: 0,
                                                     height: 0),
                                 cornerRadius: cornerRadius))

        return path
    }

    private func createFinalPath(for frame: CGRect, cornerRadius: CGFloat = 0, offset: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath(rect: viewRoot.bounds)

        let finalRect = CGRect(x: frame.origin.x - offset,
                               y: frame.origin.y - offset,
                               width: frame.width + offset * 2,
                               height: frame.height + offset * 2)

        path.append(UIBezierPath(roundedRect: finalRect, cornerRadius: cornerRadius))

        return path
    }

    private func addAnimationToMaskLayer(willShowHighlight: Bool) {
        guard
            let startPath = startPath,
            let finalPath = finalPath,
            let maskLayer = viewRoot.layer.mask as? CAShapeLayer
        else { return }

        let animation = CABasicAnimation(keyPath: "path")

        animation.fromValue = willShowHighlight ? startPath.cgPath : finalPath.cgPath
        animation.toValue = willShowHighlight ? finalPath.cgPath : startPath.cgPath
        animation.duration = ControllerOnboarding.standartDuration
        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)

        maskLayer.add(animation, forKey: nil)
        maskLayer.path = willShowHighlight ? finalPath.cgPath : startPath.cgPath
    }
    
    func animateMaskLayer(for view: UIView?, cornerRadius: CGFloat = 0, offset: CGFloat = 0) {
        guard let highlightedView = view else { return }

        let projectedFrame = createProjectedFrame(for: highlightedView)

        let startPath = createStartPath(for: projectedFrame, cornerRadius: cornerRadius)
        self.startPath = startPath

        let finalPath = createFinalPath(for: projectedFrame, cornerRadius: cornerRadius, offset: offset)
        self.finalPath = finalPath

        let backgroundOverlay: CAShapeLayer = {
            let layer = CAShapeLayer()
            layer.path = startPath.cgPath
            layer.fillRule = .evenOdd
            return layer
        }()

        viewRoot.layer.mask = backgroundOverlay

        addAnimationToMaskLayer(willShowHighlight: true)
    }
    
    //

    // MARK: - Text animaiton

    //
    
    private func animate(label: UILabel) {
        label.isHidden = false
        
        viewRoot.layoutIfNeeded()
        
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 0
        opacity.toValue = 1

        let position = CABasicAnimation(keyPath: "position.y")
        
        position.fromValue = label.layer.position.y + 30
        position.toValue = label.layer.position.y

        group.animations = [opacity, position]
        
        label.layer.add(group, forKey: nil)
    }
    
    private func removeWithAnimation(label: UILabel) {
        let group = CAAnimationGroup()
        group.duration = 0.5
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.setValue("label.remove", forKey: "name")
        group.setValue(label, forKey: "removedLabel")
        group.delegate = self
        group.isRemovedOnCompletion = true
        
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.fromValue = 1
        opacity.toValue = 0

        let position = CABasicAnimation(keyPath: "position.y")
        
        position.fromValue = label.layer.position.y
        position.toValue = label.layer.position.y + 30

        group.animations = [opacity, position]

        label.layer.add(group, forKey: nil)
        label.layer.position.y = label.layer.position.y + 30
        label.layer.opacity = 0
    }
    
    //

    // MARK: - Circle animation

    //
    
    enum CircleAnimationDirection {
        case bottomTop
        case leftRight
    }
    
    private func animateCircle(with direction: CircleAnimationDirection) {
        viewCircle.isHidden = false
        viewRoot.layoutIfNeeded()
        
        switch direction {
        case .bottomTop:
            
            let scaleUp = CABasicAnimation(keyPath: "transform.scale")
            scaleUp.duration = 0.3
            scaleUp.fillMode = .backwards
            scaleUp.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            scaleUp.fromValue = 0.01
            scaleUp.toValue = 1
            scaleUp.setValue("circle.scaleUp", forKey: "name")
            scaleUp.delegate = self
            scaleUp.isRemovedOnCompletion = true
            
            viewCircle.layer.add(scaleUp, forKey: nil)
            
        case .leftRight:
            return
        }
    }
}

extension ControllerOnboarding: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard let name = anim.value(forKey: "name") as? String, flag else { return }
        
        // FIXME: make order in this animations
        if name == "circle.scaleUp" {
            let position = CABasicAnimation(keyPath: "position.y")
            position.duration = 0.7
            position.fillMode = .backwards
            position.timingFunction = CAMediaTimingFunction(name: .easeOut)
            position.fromValue = viewCircle.layer.position.y
            position.toValue = viewCircle.layer.position.y - 3 * .r2
            position.setValue("circle.positionUp", forKey: "name")
            position.delegate = self
            position.isRemovedOnCompletion = true
            
            viewCircle.layer.position.y = viewCircle.layer.position.y - 3 * .r2
            viewCircle.layer.add(position, forKey: nil)
        } else if name == "circle.positionUp" {
            let scaleDown = CABasicAnimation(keyPath: "transform.scale")
            scaleDown.duration = 0.3
            scaleDown.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            scaleDown.fillMode = .backwards
            scaleDown.fromValue = 1
            scaleDown.toValue = 0.01
            scaleDown.delegate = self
            scaleDown.setValue("circle.scaleDown", forKey: "name")
            scaleDown.isRemovedOnCompletion = true
            
            viewCircle.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            viewCircle.layer.add(scaleDown, forKey: nil)
        } else if name == "circle.scaleDown" {
            viewCircle.layer.position.y = viewCircle.layer.position.y + 3 * .r2
            viewCircle.transform = CGAffineTransform.identity
            animateCircle(with: .bottomTop)
        } else if name == "label.remove", let label = anim.value(forKey: "removedLabel") as? UILabel {
            label.isHidden = true
        }
    }
}
