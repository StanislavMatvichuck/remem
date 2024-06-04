//
//  MakingSnapshotsRowView.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 20.05.2023.
//

@testable import Application
import iOSSnapshotTestCase
import UIKit

protocol MakingSnapshotsRowView: FBSnapshotTestCase {
    var height: CGFloat { get }
    func make(_: [String]) -> UIView
}

extension MakingSnapshotsRowView {
    var width: CGFloat { UIScreen.main.bounds.width }
    var scale: CGFloat { 1.0 }
    var spacing: CGFloat { 16.0 * scale }
    
    func make(_ testCases: [String]) -> UIView {
        let size = CGFloat(testCases.count)
        let atlasSize = CGSize(
            width: size * (width + spacing) * scale,
            height: 1 * (height) * scale
        )
        let atlasFrame = CGRect(origin: .zero, size: atlasSize)
        let view = UIView(frame: atlasFrame)
        view.addAndConstrain(makeRow(testNames: testCases))
        view.backgroundColor = .remem_bg
        return view
    }
    
    private func makeRow(testNames: [String]) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = spacing * scale
        
        for name in testNames {
            horizontalStack.addArrangedSubview(makeImageViewFor(testName: name))
        }
        
        return horizontalStack
    }
    
    private func makeImageViewFor(testName: String) -> UIImageView {
        let view = UIImageView(image: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: width * scale),
            view.heightAnchor.constraint(equalToConstant: height * scale),
        ])
        
        let directory = getReferenceImageDirectory(withDefault: nil).appending("_64")
        let path = "\(directory)/\(deviceName)/light/\(testName).png"
        
        if let image = UIImage(contentsOfFile: path) {
            view.image = image
        } else { print("image not found for \(path)") }
        
        return view
    }
}
