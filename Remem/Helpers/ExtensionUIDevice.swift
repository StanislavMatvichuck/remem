//
//  ExtensionUIDevice.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 21.01.2022.
//

import AVFoundation
import UIKit

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
