//
//  ControllerOnboarding.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 23.02.2022.
//

import UIKit

class ControllerOnboarding {
    //

    // MARK: - Static properties

    //
    
    static let standartDuration = TimeInterval(0.5)
    
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewOnboarding()
    
    fileprivate weak var mainController: ControllerMain?
    
    //
    
    // MARK: - Initialization
    
    //
    
    init(main: ControllerMain) {
        mainController = main
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    //

    // MARK: - Events handling

    //
    
    @objc private func handleTap() {
        print(#function)
        
        addAnimationToMaskLayer(isShown: false)
        
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
        
        let viewWindow = UIApplication.shared.keyWindow
        
        viewWindow?.addSubview(viewRoot)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewRoot.alpha = 1
        }, completion: { _ in
            self.showGreeting()
        })
    }
    
    //

    // MARK: Highlighting

    //
    
    private var startPath: UIBezierPath?

    private var finalPath: UIBezierPath?
    
    private func createProjectedFrame(for view: UIView) -> CGRect {
        let viewWindow = UIApplication.shared.keyWindow!.rootViewController!.view

        let frame = view.convert(view.bounds, to: viewWindow)

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

    private func addAnimationToMaskLayer(isShown: Bool) {
        guard
            let startPath = startPath,
            let finalPath = finalPath,
            let maskLayer = viewRoot.layer.mask as? CAShapeLayer
        else { return }

        let animation = CABasicAnimation(keyPath: "path")

        animation.fromValue = isShown ? startPath.cgPath : finalPath.cgPath
        animation.toValue = isShown ? finalPath.cgPath : startPath.cgPath
        animation.duration = ControllerOnboarding.standartDuration
        animation.fillMode = .backwards
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)

        maskLayer.add(animation, forKey: nil)
        maskLayer.path = isShown ? finalPath.cgPath : startPath.cgPath
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

        addAnimationToMaskLayer(isShown: true)
    }
    
    //

    // MARK: Steps description

    //
    
    func showGreeting() {
        //
        // First label
        //
        
        let label: UILabel = {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: .font1)
            label.textColor = .label
            label.numberOfLines = 0
            label.text = """
            Greetings.
            
            I am tracking app, my name is Remem and I am designed to help you with following questions:

            - when did an event last happened?
            - how many events happen in a week?
            """
            
            return label
        }()
        
        viewRoot.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: viewRoot.safeAreaLayoutGuide.topAnchor),
            label.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .delta1),
            label.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.delta1),
//            label.topAnchor.constraint(equalTo: viewRoot.safeAreaLayoutGuide.topAnchor),
        ])
        
        //
        // Second label
        //
        
        let label2: UILabel = {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: .font1)
            label.textColor = .label
            label.numberOfLines = 0
            label.text = """
            You can use me to track things like smoking a cigarette, drinking cup of coffee, doing morning  exercises or taking pills.
            """
            
            return label
        }()
        
        viewRoot.addSubview(label2)
        
        NSLayoutConstraint.activate([
            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .delta1),
            label2.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .delta1),
            label2.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.delta1),
        ])
        
        //
        // Third label
        //
        
        let label3: UILabel = {
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: .font1)
            label.textColor = .label
            label.numberOfLines = 0
            label.text = """
            Start is easy: swipe up the screen to create an event.
            """
            
            return label
        }()
        
        viewRoot.addSubview(label3)
        
        NSLayoutConstraint.activate([
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: .delta1),
            label3.leadingAnchor.constraint(equalTo: viewRoot.leadingAnchor, constant: .delta1),
            label3.trailingAnchor.constraint(equalTo: viewRoot.trailingAnchor, constant: -.delta1),
        ])
        
        //
        // Highlight
        //
        
        animateMaskLayer(for: mainController?.viewRoot.viewSwiper, cornerRadius: 0, offset: 0)
    }
}
