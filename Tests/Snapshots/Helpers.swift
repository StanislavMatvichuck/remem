//
//  SnapshotsHelpers.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 26.01.2023.
//

import iOSSnapshotTestCase
import UIKit

extension EventDetailsViewControllerTesting {
    func executeWithDarkMode(_ testCase: () -> Void) {
        sut.view.window?.overrideUserInterfaceStyle = .dark
        testCase()
    }
}

extension UIUserInterfaceStyle: CustomStringConvertible {
    public var description: String {
        switch self {
        case .dark: return "dark style"
        case .light: return "light style"
        case .unspecified: return "unspecified style"
        @unknown default:
            return "unspecified style"
        }
    }
}

extension FBSnapshotTestCase {
    func configureCommonOptions() {
        recordMode = false
        fileNameOptions = [.screenSize]
        folderName = "\(String(describing: type(of: self)))".replacingOccurrences(of: "Snapshots", with: "")
    }
}
