//
//  ExtensionUIDevice.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.01.2022.
//

import AVFoundation
import UIKit.UIDevice

extension UIDevice {
    static func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
}
