//
//  ClockFace.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 27.05.2022.
//

import UIKit

class ClockFace: UIView {
    var variant: ClockController.ClockVariant
    var sectionsAnimator: ClockSectionsAnimator
    var timer: Timer?

    init(variant: ClockController.ClockVariant) {
        self.variant = variant
        sectionsAnimator = ClockSectionsAnimator(variant: variant)
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit { timer?.invalidate() }

    override func layoutSubviews() {
        super.layoutSubviews()

        sectionsAnimator.installSections(in: self)

        setupTickingTimer()
    }
}

extension ClockFace {
    private func setupTickingTimer() {
        if timer == nil {
            let currentSeconds = Calendar.current.dateComponents([.second], from: Date.now).second ?? 0
            let secondAfterMinuteUpdates = Double(60 - currentSeconds)

            DispatchQueue.main.asyncAfter(deadline: .now() + secondAfterMinuteUpdates) { [weak self] in
                self?.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                                   target: self,
                                                   selector: #selector(self?.redraw),
                                                   userInfo: nil,
                                                   repeats: true)
            }
        }
    }

    @objc func redraw() { setNeedsDisplay() }
}
