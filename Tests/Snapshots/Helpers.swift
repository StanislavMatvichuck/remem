//
//  SnapshotsHelpers.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 26.01.2023.
//

import iOSSnapshotTestCase
import UIKit

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
        fileNameOptions = [.none]
        let deviceName = UIDevice.current.name
        folderName = "\(deviceName)/light/\(String(describing: type(of: self)))".replacingOccurrences(of: "Snapshots", with: "")
    }
}

extension UIView {
    func addAndConstrain(_ view: UIView, constant: CGFloat = 0) {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            view.topAnchor.constraint(equalTo: topAnchor, constant: constant),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1 * constant),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1 * constant),
        ])
    }
}
