//
//  ExtensionUIDevice.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.01.2022.
//

import AVFoundation
import UIKit

extension UIDevice {
    static func vibrate(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackgenerator.prepare()
        impactFeedbackgenerator.impactOccurred()
    }
}
